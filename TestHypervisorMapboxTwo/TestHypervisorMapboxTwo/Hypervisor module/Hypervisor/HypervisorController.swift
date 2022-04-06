
import HypervisorCore
import GEOSwift
import CoreLocation.CLLocation
import MapKit

private let logTag = "Hypervisor"

internal func log(_ level: LogLevel, _ message: String) {
    HypervisorCoreController.logger?.log(level, logTag, message)
}

public class HypervisorController {
    
    // MARK: - Public static properties
    
    /// The socket base URL the SDK uses to connect to.
    public static var socketEnvironment = HypervisorWebSocketEnvironment.beta {
        didSet {
            log(.debug, "Socket environment = \(socketEnvironment.rawValue) - URL = \(socketEnvironment.url)")
        }
    }
    
    // MARK: - Private static properties
    private static let beMobileAPIKey = "be-mobile-api-key"
    
    // MARK: - Instance properties
    
    private var routePartFinished = false
    
    /// Instance for delegation of events defined in the `HypervisorDelegate` protocol.
    public private(set) weak var delegate: HypervisorDelegate?
    
    /// Options that configure the behaviour ot the Hyperviros SDK.
    public private(set) var options: HypervisorOptions = .init()
    
    /// The soket manager instance.
    private lazy var socketManager = HypervisorSocketManager(delegate: self)
    
    
    private var allowedTransferTypes: [PluginConfig] {
        let allowedModi = options.allowedTransferTypes.filter({![TransferType.segway, .transfer].contains($0)})
        
        
        return [
            PluginConfig(config: AlternativesConfig(alternativeModi: options.alternativeModi,
                                              selectedModi: allowedModi,
                                              selectedSharedMobilityProviders: options.selectedSharedMobilityProviders,
                                              amountAlternatives: options.alternativeRoutesAmount,
                                              carDelayPercentage: options.carDelayPercentage))
        ]
    }
    
    private(set) var alternativeRoutes: AlternativeRouteMessage? = nil {
        willSet {
            if (newValue != alternativeRoutes) {
                if let alternatives = alternativeRoutes {
                    delegate?.onAlternativeRoutesReceived(routes: alternatives.alternatives.map { $0.route })
                }
            }
        }
    }
    
    /// The trip identifier provided by the socket, used to identify the active route/trip.
    public private(set) var tripId: String? {
        didSet {
            guard
                tripId != oldValue,
                let activeRoute = activeRoute,
                let tripId = tripId
            else { return }
            
            log(.debug, "Trip ID = \(tripId)")
            
            socketManager.sendMessage(InitInteractionCommand(routeId: tripId, message: RouteInfoMessage(route: activeRoute, plugins: allowedTransferTypes)))
        }
    }
    
    /// Timer instance that triggers new location updates to the socket.
    private var locationUpdateTimer: Timer?
    
    /// Completion handler for the initialization of the route.
    /// The route is not fully initialized until the socket responds with a connect response containing the `tripId`.
    /// This handler is triggered when that condition is met, allowing the SDK client to start the route.
    /// This handler may not trigger when the route initialization does not succeed. The SDK client could implement a timeout to handle this.
    public private(set) var initializeRouteCompletion: (() -> Void)?
    
    /// The active part/leg index
    /// This index indicates which part of the active route is currently active.
    public private(set) var activeLegNumber: Int = -1 {
        didSet {
            guard activeLegNumber != oldValue else { return }
            
            log(.debug, "Active leg = \(activeLegNumber)")
            
            guard let activePart = activePart else {
                activePartLineString = nil
                return
            }
                        
            activePartLineString = activePart.makeLineString()
            
            if let oldPart = activeRoute?.parts[safe: oldValue] {
                log(.debug, "Part stopped. Mode = \(oldPart.mode). Distance: \(oldPart.distance).")
                if !routePartFinished {
                    delegate?.onRoutePartStopped(part: oldPart)
                }
            }
            
            log(.debug, "Active part updated. Mode = \(activePart.mode). Distance: \(activePart.distance).")
            
            if let tripId = tripId {
                delegate?.onRoutePartStarted(part: activePart)
                
                socketManager.sendMessage(StartPartInteractionCommand(tripId: tripId, message: PartUpdateMessage(partUpdate: Update(id: activeLegNumber))))
            }
        }
    }
    
    /// The active route
    public private(set) var activeRoute: HypervisorRoute? {
        didSet {
            guard activeRoute != oldValue else { return }
            
            log(.debug, "Active route updated")
            
            activePartLineString = activePart?.makeLineString()

            if let activeRoute = activeRoute {
                if !activeRoute.parts.isEmpty {
                    delegate?.onRouteUpdated(route: activeRoute)
                }
            }
        }
    }
    
    /// Cached LineString of active part
    /// It cached because it is used every location update, but does not change that often.
    private var activePartLineString: LineString?
    
    /// The location where the user started deviating.
    private var deviationLocation: Location?
    
    /// Boolean flag indicating if the user is currently deviating from the active part.
    private var userIsDeviating = false {
        didSet {
            guard userIsDeviating != oldValue else { return }
            
            log(.debug, "User is deviating = \(userIsDeviating)")
            
            delegate?.onUserDeviatedFromRoute(isUserDeviated: userIsDeviating)
            startCheckingLocation()
            if !userIsDeviating {
                deviationLocation = nil
            }
        }
    }
    
    /// The part of the active route (`activeRoute`), index by `activeLegNumber`.
    /// `nil` if no route is active.
    public var activePart: RoutePart? {
        activeRoute?.parts[safe: activeLegNumber]
    }
    
    /// Estimated time of arrival.
    /// This value is updated by the socket.
    private var eta: ETAResponseMessage? {
        didSet {
            
            log(.debug, "ETA = \(String(describing: eta))")
            
            if let eta = eta {
                delegate?.onETAChanged(eta: eta)
            }
        }
    }
    
    /// Delay on current route.
    /// This value is updated by the socket.
    private var delay: Delay? {
        didSet {
            
            log(.debug, "Delay = \(String(describing: delay))")
            
            if let delay = delay {
                delegate?.onDelayReceived(delay: delay)
            }
        }
    }
    
    /// Public transport information.
    /// This value is updated by the socket.
    private var publicTransferStopInfo: PublicTransportStopInfo? {
        didSet {
            
            log(.debug, "Public transfer stop info = \(String(describing: publicTransferStopInfo))")
            
            if let publicTransferStopInfo = publicTransferStopInfo {
                delegate?.onPublicTransportStopChanged(publicTransportStopInfo: publicTransferStopInfo)
            }
        }
    }
    
    /// Infeasibility reason
    /// This value is updated by the socket.
    private var infeasibilityReason: InfeasibilityReason? {
        didSet {
            
            log(.debug, "Infeasibility reason = \(String(describing: infeasibilityReason))")
            
            if let infeasibilityReason = infeasibilityReason {
                delegate?.onInfeasibleReceived(infeasibilityReason: infeasibilityReason)
            }
        }
    }
    
    /// Boolean flag indicating wether the user is close to the destination of the current route part.
    private var isUserWithinDestination = false {
        didSet {
            guard isUserWithinDestination != oldValue else { return }
            
            log(.debug, "User within destination = \(isUserWithinDestination)")
            
            startCheckingLocation()
        }
    }
    
    /// Value indicating the distance between the user and the upcoming transfer zone of the current route part..
    private var distanceFromTransferZone: Double = 0.0 {
        didSet {
            guard distanceFromTransferZone != oldValue else { return }
            
            log(.debug, "Distance from transfer zone = \(distanceFromTransferZone)")
            
            if Int(distanceFromTransferZone) <= options.userDestinationRadius {
                delegate?.onUserInRangeOfDestination(distance: distanceFromTransferZone)
                isUserWithinDestination = true
            } else if isUserWithinDestination {
                delegate?.onUserInRangeOfDestination(distance: nil)
                isUserWithinDestination = false
            }
            
            // Only sent transfer updated when the user is at least within the outer zone radius.
            if distanceFromTransferZone <= ZoneRadius.outerRadius.rawValue, let tripId = tripId {
                
                let radiuszone: Int = {
                    switch distanceFromTransferZone {
                    case let radius where radius <= ZoneRadius.innerRadius.rawValue: return 0
                    case let radius where radius <= ZoneRadius.middleRadius.rawValue: return 1
                    default: return 2
                    }
                }()
                
                socketManager.sendMessage(
                    StartTransferInteractionCommand(
                        tripId: tripId,
                        message: TransferUpdateMessage(transferUpdate: TransferUpdate(id: activeLegNumber, radiuszone: radiuszone))
                    )
                )
            }
        }
    }
    
    // MARK: - Init
    
    public init() {
        
    }
    
    /// Resets instance variables to their default value.
    private func setDefaults() {
        
        log(.debug, "Resetting to defaults")
        
        delegate = nil
        tripId = nil
        userIsDeviating = false
        setDefaultsForAlternative()
        deviationLocation = nil
        isUserWithinDestination = false
        distanceFromTransferZone = 0.0
        options = .init()
        initializeRouteCompletion = nil

        stopCheckingLocation()
    }
    
    /**
     * Sets all the properties back for when a alternative route is found
     */
    private func setDefaultsForAlternative() {
        activeRoute = nil
        activePartLineString = nil
        activeLegNumber = -1
        routePartFinished = false
    }
    
    // MARK: - Route
    
    /// Function to initialize a new `HypervisorRoute`
    /// - Parameters:
    ///   - route: The `HypervisorRoute` instance.
    ///   - delegate: Delegate instance.
    ///   - options: Options used to configure the SDK.
    ///   - completion: Completion handler for the initialization of the route. See `initializeRouteCompletion` property.
    public func initializeRoute(route: HypervisorRoute, delegate: HypervisorDelegate, options: HypervisorOptions, completion: @escaping () -> Void) {
        
        var urlComponents = URLComponents(string: Self.socketEnvironment.url)!
        urlComponents.queryItems = [
            .init(name: Self.beMobileAPIKey, value: Self.socketEnvironment.apiKey)
        ]
        
        guard let url = urlComponents.url else {
            log(.error, "Could not initialize route: Invalid URL components")
            assertionFailure()
            return
        }
        
        log(.debug, "Initializing route. Options: \(options)")
        
        socketManager.forceDisconnect()
        
        setDefaults()
        
        self.initializeRouteCompletion = completion
        self.delegate = delegate
        self.options = options
        self.activeRoute = route
        
        socketManager.connect(url: url)
    }
    
    /// Function to start the `HypervisorRoute` provided though the `initializeRoute` function.
    /// Connects and initizes the socket.
    /// Call this function after the completion handler of `initializeRoute` is fired.
    public func startRoute() {
        guard let route = activeRoute else {
            assertionFailure("Initialize a hypervisor route before starting it.")
            return
        }
        
        guard let tripId = tripId else {
            assertionFailure("No tripId set.")
            return
        }
        
        log(.debug, "Starting route")
        
        socketManager.sendMessage(StartInteractionCommand(tripId: tripId))
        
        activeLegNumber = 0
        routePartFinished = true
        startCheckingLocation()
        delegate?.onRouteStarted(route: route)
    }
    
     /// Activates the initialized route and start checking the route.
     /// You can only call this method after the route is initialized. So call @initActiveRoute
    public func startAlterRoute(route: HypervisorRoute) {
        guard let alterRouteMessage = alternativeRoutes?.alternatives.first(where: {$0.route == route}) else {
            return
        }
        
        if let activeRoute = activeRoute {
            delegate?.onRouteStopped(route: activeRoute)
        }
        
        setDefaultsForAlternative()
        
        activeRoute = alterRouteMessage.route
        
        guard let activeRoute = activeRoute, let tripId = tripId else { return }
        
        socketManager.sendMessage(AlterRouteCommand(alterRouteMessage, tripId))
        alternativeRoutes = nil
        activeLegNumber = 0
        routePartFinished = false
        startCheckingLocation()
        delegate?.onRouteStarted(route: activeRoute)
    }
    
    
    /// Stops the active route.
    /// DIsconnects from the socket and resets the state of the SDK.
    public func stopRoute() {
        
        log(.debug, "Stopping route")
        
        stopCheckingLocation()
        if let activeRoute = activeRoute {
            delegate?.onRouteStopped(route: activeRoute)
        }
        if let tripId = tripId {
            socketManager.sendMessage(StopInteractionCommand(tripId: tripId))
        }
        socketManager.disconnect(reason: "")
        setDefaults()
    }
    
    // MARK: - Location updates
    
    /// (re)schedules with the correct interval, and immediately invokes, the location update timer.
    private func startCheckingLocation() {
        locationUpdateTimer?.invalidate()
        
        let interval: TimeInterval
        if userIsDeviating {
            interval = options.intervalTimeAtDeviation
        } else if isUserWithinDestination {
            interval = options.intervalTimeAtDestination
        } else {
            interval = options.intervalTime
        }
        
        log(.debug, "Starting to check location with interval: \(interval)")
        
        locationUpdateTimer = .scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] _ in
            self?.updateLocation()
        })
        locationUpdateTimer?.tolerance = interval / 10
        locationUpdateTimer?.fire()
    }
    
    /// Stops the location updates.
    private func stopCheckingLocation() {
        
        log(.debug, "Stopping to check location")
        
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    
    private var lastCheckedLocation: Location?
    
    /// Executes a location update and sends it to the socket.
    /// Also invokes checks wether the user is deviating of close to the destination.
    /// Starts the next route part if needed and allowed.
    private func updateLocation() {
        guard let location = delegate?.getLastKnownLocation() else {
            log(.warn, "Could not update location. Delegate did not provide a location.")
            return
        }
        
        let timeStampString = DateUtil.dateFormatter.string(from: location.timestamp)
        let hypervisorLocation = Location(
            version: "1",
            providerId: 1,
            dateTime: timeStampString,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            speedKmH: Int(max(0, location.speed * 3.6)),
            heading: Int(max(0, location.course)),
            receivedDate: timeStampString,
            vehicleId: activePart?.mode.rawValue ?? ""
        )
        
        guard lastCheckedLocation?.latitude != hypervisorLocation.latitude && lastCheckedLocation?.longitude != hypervisorLocation.longitude else { return }
        lastCheckedLocation = hypervisorLocation
        
        log(.debug, "Updating location")
        
        if let tripId = tripId {
            socketManager.sendMessage(UpdateLocationInteractionCommand(tripId: tripId, message: LocationMessage(location: hypervisorLocation)))
        }
        
        if checkIfUserFinishedCurrentPart(userLocation: hypervisorLocation) && options.autoStartPart {
            startNextPart()
        }
        checkIfUserIsWithinRangeOfDestination(userLocation: hypervisorLocation)
        checkIfUserIsDeviating(userLocation: hypervisorLocation)
    }
    
    /// Check if the user is deviating from the active route part.
    private func checkIfUserIsDeviating(userLocation: Location) {
        
        guard
            let tripId = tripId,
            let activePartLineString = activePartLineString
        else {
            return
        }
        
        let userCoordinate = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        // Convert CLLocationCoordinate2D's, via MKMapPoint's to CGPoint's, to use them in the upcoming algorithm.
        let coordinateCGMapPoints = activePartLineString.points
            .map { CLLocationCoordinate2D(latitude: $0.y, longitude: $0.x) }
            .map { MKMapPoint($0) }
            .map { CGPoint($0) }
        
        // Pair each coordinate-point with it successor.
        let coordinatePairs: [(current: CGPoint, next: CGPoint)] = coordinateCGMapPoints.enumerated()
            .compactMap { ($0.element, coordinateCGMapPoints[safe: $0.offset + 1] ?? $0.element) }
        
        // Convert the user coordinate to a MKMapPoint as well.
        let userLocationMapPoint = MKMapPoint(userCoordinate)
        
        // Loop over the coordinate-point pairs until there is a pair that lays close the user coodinate.
        let isUserDeviating = coordinatePairs.first {
            CGPoint(userLocationMapPoint)
                .closestPointOnLine(
                    pointA: $0.current,
                    pointB: $0.next
                )
                .mkMapPoint
                .distance(to: userLocationMapPoint)
                .isLessThanOrEqualTo(options.deviationTolerance)
        }
        .isNil()
        
        userIsDeviating = isUserDeviating
        guard isUserDeviating else { return }
        
        // Wait for the second location that deviates before sending it to the socket.
        // If `deviationLocation` is set, this means the previous check determined a deviation as well.
        if let deviationLocation = deviationLocation {
            if
                let activeRoute = activeRoute,
                let lineString = try? activeRoute.makeFullRouteLineString(),
                let wktString = try? lineString.wkt() {
                
                socketManager.sendMessage(
                    DeviationInteractionCommand(
                        routeId: tripId,
                        message: DeviatedLocationMessage(location: userLocation, deviation: deviationLocation, geo: wktString)
                    )
                )
            }
        } else {
            // Store the location where the deviation happened fo future deviation socket messages.
            deviationLocation = userLocation
            // Note: `deviationLocation` is reset to `nil` when `userIsDeviating` is `false`.
        }
    }
    
    /// Check if the user is in range of the destination of the active route part according to the given radius of the hypervisorOptions.
    private func checkIfUserIsWithinRangeOfDestination(userLocation: Location) {
        
        guard let destination = activePartLineString?.lastPoint else { return }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destinationCLLocation = CLLocation(latitude: destination.y, longitude: destination.x)
        
        distanceFromTransferZone = userCLLocation.distance(from: destinationCLLocation)
        
        guard
            let lastPart = activeRoute?.parts.last,
            activePart == lastPart,
            Int(distanceFromTransferZone) <= options.destinationReachedRadius
        else {
            return
        }
        
        log(.debug, "Destination reached")
        routePartFinished = true
        delegate?.onRoutePartFinished(part: lastPart)
        delegate?.onDestinationReached()
    }
    
    /// Check if the user finished his current part and is in range of the next leg.
    private func checkIfUserFinishedCurrentPart(userLocation: Location) -> Bool {
        
        guard
            let activeRoute = activeRoute,
            let nextRoutePart = activeRoute.parts[safe: activeLegNumber + 1],
            let nextRoutePartFirstPoint = nextRoutePart.makeLineString()?.firstPoint
        else {
            return false
        }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let nextRoutePartFirstPointCLLocation = CLLocation(latitude: nextRoutePartFirstPoint.y, longitude: nextRoutePartFirstPoint.x)
        
        distanceFromTransferZone = userCLLocation.distance(from: nextRoutePartFirstPointCLLocation)
        
        if Int(distanceFromTransferZone) <= options.endOfLegRadius {
            log(.debug, "Active route part is finished. Mode: \(activePart?.mode.rawValue)")
            if let activePart = activePart {
                routePartFinished = true
                delegate?.onRoutePartFinished(part: activePart)
            }
            return true
        }
        return false
    }
    
    /// Starts the next part
    public func startNextPart() {
        if activePart != activeRoute?.parts.last {
            log(.debug, "Starting next route part")
            activeLegNumber = activeLegNumber + 1
            routePartFinished = false
        }
    }
    
    public func startPreviousPart() {
        if activePart != activeRoute?.parts.first {
            log(.debug, "Starting previous route part")
            activeLegNumber = activeLegNumber - 1
            routePartFinished = false
        }
    }
    
    // MARK: - Incoming socket messages
    
    /// Handles the messages from the websocket.
    private func handleMessage(_ message: String) throws {
        
        guard
            let jsonData = message.data(using: .utf8),
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        else {
            log(.error, "Can't handle message received from websocket. [response: \(message)]")
            assertionFailure()
            return
        }
        
        if let errorJSON = json["error"] as? [String: Any] {
            log(.error, "Message received from websocket contains error: \(errorJSON)")
            return
        }
        
        if let commandString = json[MessageTypes.command.rawValue] as? String, let command = CommandStates(rawValue: commandString) {
            switch command {
            case .connect, .reconnect:
                log(.info, "Connected with websocket.")
                let response = try JSONDecoder().decode(ConnectResponse.self, from: jsonData)
                tripId = response.message.id
                initializeRouteCompletion?()
                initializeRouteCompletion = nil
                
            case .start:
                log(.info, "Route started with websocket.")
                
            case .stop:
                log(.info, "Route stopped with websocket.")
                tripId = nil
                
            case .startPart:
                log(.info, "Route part started with websocket.")
                
            case .startTransfer:
                log(.info, "Transfer started with websocket.")
                
            case .updateLocation:
                log(.info, "Location synced with websocket.")
                
            case .deviation:
                log(.info, "Deviation synced with websocket.")
                
            case .initialize:
                log(.info, "Route initialized with websocket.")
                
            case .alterRoute:
                log(.info, "Alternative route initiated with websocket.")
            }
        }
        else if let eventString = json[MessageTypes.type.rawValue] as? String, let event = EventTypes(rawValue: eventString) {
            switch event {
            case .rerouteDeviationEvent:
                log(.info, "New route found because of deviation [response: \(message)]")
                let response = try JSONDecoder().decode(DeviationResponse.self, from: jsonData)
                updateRoutePart(deviationResponse: response)
                
            case .etaEvent:
                log(.info, "New ETA event [response: \(message)]")
                let response = try JSONDecoder().decode(ETAResponse.self, from: jsonData)
                eta = response.message
                
            case .arrivalDelayEvent:
                log(.info, "Arrival delay event [response: \(message)]")
                let response = try JSONDecoder().decode(ArrivalDelayResponse.self, from: jsonData)
                delay = Delay(type: .arrival, delayMs: response.message.arrivalDelayMs)
                
            case .departureDelayEvent:
                log(.info, "Departure delay event [response: \(message)]")
                let response = try JSONDecoder().decode(DepartureDelayResponse.self, from: jsonData)
                delay = Delay(type: .departure, delayMs: response.message.departureDelayMs)
                
            case .cancellationEvent:
                log(.info, "Transfer cancellation event [response: \(message)]")
                let response = try JSONDecoder().decode(CancellationResponse.self, from: jsonData)
                publicTransferStopInfo = PublicTransportStopInfo(type: .cancellation, info: [response.message.cancelledPublicTransportStop])
                
            case .transferUpdateEvent:
                log(.info, "Transfer updated event [response: \(message)]")
                let response = try JSONDecoder().decode(TransferUpdateResponse.self, from: jsonData)
                publicTransferStopInfo = PublicTransportStopInfo(type: .update, info: [response.message.transferUpdatePublicTransportStop])
                
            case .publicTransportProgressEvent:
                log(.info, "Transfer progress event [response: \(message)]")
                let response = try JSONDecoder().decode(PublicTransportProgressResponse.self, from: jsonData)
                publicTransferStopInfo = PublicTransportStopInfo(type: .progress, info: response.message.progressPublicTransportStops)
                
            case .infeasibleEvent:
                log(.info, "Infeasible event [response: \(message)]")
                let response = try JSONDecoder().decode(InfeasibleResponse.self, from: jsonData)
                infeasibilityReason = response.message.infeasibilityReason
                
            case .routeArrivalDelayEvent:
                log(.info, "Route arrival delay event [response: \(message)]")
                let response = try JSONDecoder().decode(RouteArrivalDelayResponse.self, from: jsonData)
                delay = Delay(type: .routeArrival, delayMs: response.message.delayMs)
                
            case .alternativesEvent:
                log(.info, "Alternative event [response: \(message)]")
                let response = try JSONDecoder().decode(AlternativesResponse.self, from: jsonData)
                alternativeRoutes = response.message
            }
        }
        else {
            log(.info, "Event received [response: \(message)]")
            delegate?.onEventReceived(event: message)
        }
    }
    
    /// Updates the active route with a deviation received from the socket.
    private func updateRoutePart(deviationResponse: DeviationResponse) {
        
        guard
            let activePart = activePart,
            let activeRoute = activeRoute
        else { return }
        
        let updatedRoutePart = RoutePart(
            geo: deviationResponse.message.geo,
            mode: activePart.mode,
            distance: deviationResponse.message.distance,
            publicTransportInfo: activePart.publicTransportInfo,
            sharedMobilityInfo: activePart.sharedMobilityInfo,
            arrivalTime: deviationResponse.message.arrivalTime,
            departureTime: deviationResponse.message.departureTime
        )
        
        var updatedRouteParts = activeRoute.parts
        updatedRouteParts[activeLegNumber] = updatedRoutePart
        
        let updatedActiveRoute = HypervisorRoute(parts: updatedRouteParts)
        self.activeRoute = updatedActiveRoute
        
        delegate?.onRouteUpdated(route: updatedActiveRoute)
    }
}

extension HypervisorController: HypervisorSocketManagerDelegate {
    
    func onConnected() {
        let timestampString = DateUtil.dateFormatter.string(from: Date())
        if let tripId = tripId {
            socketManager.sendMessage(ReconnectCommand(id: tripId, timestamp: timestampString))
        } else {
            socketManager.sendMessage(ConnectCommand(timestamp: timestampString))
        }
    }
    
    func onFailed(error: Error?) {
        log(.error, "Socket failed. Error: \(error?.localizedDescription)")
    }
    
    func onClose() {
    }
    
    func onMessage(message: String) {
        do {
            try handleMessage(message)
        } catch {
            log(.error, "Could not handle incoming message. Error: \(error.localizedDescription)")
        }
    }
}
