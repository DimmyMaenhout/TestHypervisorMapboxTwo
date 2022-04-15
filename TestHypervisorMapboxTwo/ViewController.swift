//
//  ViewController.swift
//  TestHypervisorMapbox
//
//  Created by Dimmy Maenhout on 22/03/2022.
//

import UIKit

import Mapbox
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

import Turf

// MARK: - Mapbox navigation 0.40.0

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var navService: MapboxNavigationService?
    private var navigationMapView: NavigationMapView!
    
    private var wayPoints: [Waypoint]?
    
    private var config: MapboxNavigationModuleConfig!
    
    private let hypervisorKey = "1kPs1290ZxhQV7FoxRe3XqxoBOS"
    private let mapboxKey = "pk.eyJ1Ijoic2VudGFzIiwiYSI6ImNramg0dmxhazk3eWEzMXFqbHY0cGc3ZWkifQ.B6kmxSEPA6W_lida1p6MWQ"
    
    private let hypervisor: HypervisorController = {
        return HypervisorController()
    }()
    
    private var voiceController: RouteVoiceController!
    
    private var isBeta = false
    
    private var tracksUserCourse = false
    
    // MARK: - Lifecycle
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
    
            setupMapView()
    
            HypervisorController.socketEnvironment = isBeta ? HypervisorWebSocketEnvironment.beta : HypervisorWebSocketEnvironment.production
            print("HypervisorController.socketBaseUrl: \(HypervisorController.socketEnvironment)")
            RouteConverterApiService.baseURL = isBeta ? RouteConverterApiService.BaseURL(rawValue: Settings.routeConverterBaseURL)! : RouteConverterApiService.BaseURL.production
            print("RouteConverterApiService.baseURL: \(RouteConverterApiService.baseURL)")
            print()
    
            startNavigationFromHypervisorRouteStrings([MockData.hrPartCarTest, MockData.hrPartSharedBike, MockData.hrPartFootTest], activeRouteIndex: 0)
            
//            simulateRNRouteString()
//            convertMultipleRouteParts(multipleRoutePartString: MockData.hrPartCarBikeFoot)
//            convertHypervisorPartToMapboxRoute(routePartString: MockData.hrPartCarTest) { route in
//                print(route)
//            }
        }
    
        // MARK: - Private methods
    
        private func setupMapView() {
            navigationMapView = NavigationMapView(frame: view.bounds)
            navigationMapView?.delegate = self
            navigationMapView.navigationMapViewDelegate = self
            navigationMapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
            navigationMapView.showsUserLocation = false
            navigationMapView.tracksUserCourse = false
            navigationMapView.compassView.isHidden = true
    
            view.addSubview(navigationMapView)
        }
    
    // To simulate what we'll get back from React Native
//    private func simulateRNRouteString() {
//        convertHypervisorPartToMapboxRoute(routePartString: MockData.hrPartCarTest) { [weak self] tempRoute in
//            guard let self = self else { return }
//            guard let routeString = self.convertObjectToJsonString(object: tempRoute) else { return }
//
//            guard let routeObject: Route = self.convertJsonStringToMapboxRoute(jsonString: routeString) else {
//                print("failed converting json string to Mapbox route")
//                return
//            }
//
//            print("Mapbox route distance: \(routeObject.distance)")
//
//        }
//    }
    
    private func startNavigationFromHypervisorRouteStrings(_ hypervisorStrings: [String], activeRouteIndex: Int) {
        var routes = [Route]()

        let group = DispatchGroup()
        for routeString in hypervisorStrings {
            group.wait()
            group.enter()
            convertHypervisorPartToMapboxRoute(routePartString: routeString) { route in
                guard let route = route else {
                    print("Route was nil")
                    group.leave()
                    return
                }

                routes.append(route)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.startNavigationFromMapboxRoutes(routes, activeRouteIndex: activeRouteIndex)
        }
    }
    
    private func startNavigationFromMapboxRoutes(_ routes: [Route], activeRouteIndex: Int) {
        let route = routes[activeRouteIndex]
        guard let origin = route.legs.first
                .map ({ routeLeg in routeLeg.source })
                .flatMap({ waypoint -> CLLocationCoordinate2D? in
                    guard let coordinate = waypoint?.coordinate else { return nil }
                    return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)}),
              let destination = route.legs.last
                .map({ routeLeg in routeLeg.destination })
                .flatMap({ waypoint -> CLLocationCoordinate2D? in
                    guard let coordinate = waypoint?.coordinate else { return nil }
                    return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                }) else {
                    print("origin or destination was nil")
                    return
                }

        self.navigationMapView.setCenter(origin, zoomLevel: 15.0, animated: true)

        guard let routeShape: LineString = route.shape else {
            print("route shape is nil")
            return
        }

        let coordinates = [origin, destination]
        let waypoints = coordinates.map { Waypoint(coordinate: $0)}

        // set options
        //            let routeOptions = NavigationRouteOptions(waypoints: waypoints)
        //            let credentials = self.navigationService?.directions.credentials

        let directions = Directions(credentials: DirectionsCredentials(accessToken: "pk.eyJ1Ijoic2VudGFzIiwiYSI6ImNramg0dmxhazk3eWEzMXFqbHY0cGc3ZWkifQ.B6kmxSEPA6W_lida1p6MWQ"))

        let matchOptions = NavigationMatchOptions(coordinates: routeShape.coordinates)

        for waypoint in matchOptions.waypoints.dropFirst().dropLast() {
            waypoint.separatesLegs = false
        }

        let routeOptions = NavigationRouteOptions(waypoints: waypoints)

        let navService = MapboxNavigationService(route: route, routeOptions: routeOptions, directions: directions, locationSource: nil, eventsManagerType: nil, simulating: .always, routerType: nil)

        self.navService = navService
        self.navService?.delegate = self

        self.voiceController = RouteVoiceController(navigationService: navService)

        DispatchQueue.main.asyncAfter(deadline: .now()) {

            self.navigationMapView.userTrackingMode = .followWithHeading
            self.navigationMapView.tracksUserCourse = true
            self.tracksUserCourse = true

            self.navService?.start()

            self.navigationMapView.showcase(routes)
            for route in routes {
                self.navigationMapView.showWaypoints(on: route)
            }

            self.updateCourseTracking(location: CLLocation(latitude: origin.latitude, longitude: origin.longitude), animated: false)

            guard
                let firstInstruction = self.navService?.routeProgress.currentLegProgress.currentStepProgress.currentVisualInstruction,
                let navService = self.navService else {
                    self.voiceController = nil
                    return
                }

            self.navigationService(navService, didPassVisualInstructionPoint: firstInstruction, routeProgress: navService.routeProgress)
        }
        
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                let navigationOptions = NavigationOptions(navigationService: navService, voiceController: self.voiceController)
//                let viewController = NavigationViewController(for: route, routeOptions: routeOptions, navigationOptions: navigationOptions)
//                viewController.modalPresentationStyle = .fullScreen
//                self.present(viewController, animated: true, completion: nil)
//            }
    }
}

// MARK: - Route conversions

extension ViewController {
    private func convertHypervisorPartToMapboxRoute(routePartString: String, completionHandler: @escaping (Route?) ->  Void)  {
        guard let routePart: RoutePart = convertJsonStringToObject(jsonString: routePartString) else {
            print("<* Failed *>")
            return
        }
        
        let mapboxConfig = MapboxConfig(
            steps: true,
            locale: "nl_BE",
            profile: routePart.mode.toMapboxProfile(),
            overview: nil,
            geometries: .polyline, // .polyline6
            annotations: nil,
            roundabout_exits: nil,
            voice_instructions: true,
            voice_units: "metric",
            banner_instructions: true
        )
        
        HypervisorConverter.convertHypervisorPartToMapBoxRoute(apikey: hypervisorKey, routePart: routePart, mapboxConfig: mapboxConfig) { data in
            guard let data = data else {
                print("No json data")
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("JSON can not be parsed")
                return
            }
            
            guard let lineString = routePart.makeLineString() else {
                print("Cannot create line string for provided RoutePart with geo: \(routePart.geo)")
                return
            }
            
            let waypoints = [lineString.firstPoint, lineString.lastPoint]
                .map { CLLocationCoordinate2D(latitude: $0.y, longitude: $0.x) }
                .map { Waypoint(coordinate: $0) }
            
            // Optional step to check if json is valid
            guard
                let _ = json["distance"] as? Double,
                let _ = json["duration"] as? Double
            else {
                return print("Json is invalid")
            }
            
            do {
                let decoder = JSONDecoder()
                
                let dataString = String(data: data, encoding: .utf8)
                print("dataString: \(dataString)")
                
                let routeOptions = RouteOptions(waypoints: waypoints)
                decoder.userInfo[.options] = routeOptions
                let tempRoute = try decoder.decode(Route.self, from: data)
                print("Successfully parsed json to route: \(String(describing: tempRoute))")
                //                route = tempRoute
                completionHandler(tempRoute)
            } catch (let error) {
                print("Failed to decode JSON with error: \(error)")
                completionHandler(nil)
            }
        }
    }
}

extension ViewController: NavigationServiceDelegate {
    func navigationService(_ service: NavigationService, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
//        let routeProgressString = // convertObjectToJsonString(object: progress)
        
//        print("line 184 didUpdate progress, routeProgress: \(routeProgressString)")\
        
        print(progress.currentLegProgress.fractionTraveled)
        
//        navigationMapView.updateUpcomingRoutePointIndex(routeProgress: progress)
//        navigationMapView.updateTraveledRouteLine(location.coordinate)
//        navigationMapView.updateRoute(progress)
        
//        navigationMapView.show([progress.route])
//
        navigationMapView.updatePreferredFrameRate(for: progress)
        
        self.updateCourseTracking(location: location)
        
        if let shape = progress.route.shape {
//            navigationMapView.setOverheadCameraView(from: location.coordinate , along: shape, for: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            
            navigationMapView.updateUserLocationAnnotationView()
        }
        
    }
    
    func navigationService(_ service: NavigationService, didPassVisualInstructionPoint instruction: VisualInstructionBanner, routeProgress: RouteProgress) {
//        let routeProgressString = convertObjectToJsonString(object: routeProgress)
//        print("line 191 didPassVisualInstructionPoint, routeProgress: \(routeProgressString)")
    }
    
    func navigationService(_ service: NavigationService, didPassSpokenInstructionPoint instruction: SpokenInstruction, routeProgress: RouteProgress) {
//        let routeProgressString = convertObjectToJsonString(object: routeProgress)
//        print("line 196 didPassSpokenInstructionPoint, routeProgress: \(routeProgressString)")
        
    }
    
    func navigationService(_ service: NavigationService, willArriveAt waypoint: Waypoint, after remainingTimeInterval: TimeInterval, distance: CLLocationDistance) {

        print()
    }
    
    func navigationService(_ service: NavigationService, didArriveAt waypoint: Waypoint) -> Bool {
        
        print()
//        isNavigationActive = false
        navService?.stop()
        return true
    }
    
    func navigationService(_ service: NavigationService, didRefresh routeProgress: RouteProgress) {
        
        print("Refresh")
        print(routeProgress)
        //mapView.show([routeProgress.route])
        
//        navigationMapView.updateUpcomingRoutePointIndex(routeProgress: routeProgress)
//        mapView.updateTraveledRouteLine(navigationService.router.location?.coordinate)
//        navigationMapView.updateRoute(routeProgress)
    }
    
    func navigationService(_ service: NavigationService, willEndSimulating progress: RouteProgress, becauseOf reason: SimulationIntent) {
        print(reason)
        
    }
    
    func navigationService(_ service: NavigationService, didEndSimulating progress: RouteProgress, becauseOf reason: SimulationIntent) {
        print(reason)
    }
}

// MARK: - Actions

extension ViewController {
    func toggleVoiceInstructions(_ enabled: Bool) {
        if enabled, let navService = navService {
            self.voiceController = RouteVoiceController(navigationService: navService)
            print("Voiceassistant turned ON")
        } else {
            self.voiceController = nil
            print("Voiceassistant turned OFF")
        }
    }
    
    func recenterToTrackUser() {
        navigationMapView.tracksUserCourse = true
        tracksUserCourse = true
    }
    
    func showCompass(_ visible: Bool) {
        navigationMapView.compassView.isHidden = !visible
    }
    
    func updateCourseTracking(location: CLLocation, animated: Bool = true) {
        let camera = MGLMapCamera(lookingAtCenter: location.coordinate, altitude: 1000, pitch: 0, heading: location.course)
        navigationMapView.updateCourseTracking(location: location, camera: camera, animated: animated)
    }
}

// MARK: - Delegates

extension ViewController: MGLMapViewDelegate {
    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
//        print("mapViewRegionIsChanging tracking user: \(navigationMapView.tracksUserCourse)")
        if !navigationMapView.tracksUserCourse, tracksUserCourse {
            // TODO: Notify RN that re-center button is needed
            tracksUserCourse = false
        }
    }
    
    // Used for shake gesture for testing purposes
    override func becomeFirstResponder() -> Bool {
        return true
    }

    // Using shake gesture for testing purposes
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            print("Shake Gesture Detected")
//            toggleVoiceInstructions(voiceController == nil)
            recenterToTrackUser()
                        
        }
    }
    
    
    
}

extension ViewController: NavigationMapViewDelegate {
}

// MARK: - Convert String from RN to usable objects

extension ViewController {
    // only to test multiple hypervisor part
    private func convertMultipleRouteParts(multipleRoutePartString: String) {
        guard let routeParts: [RoutePart] = convertJsonStringToObject(jsonString: multipleRoutePartString) else {
            return
        }
        
        let routePartStrings = routeParts.map { convertObjectToJsonString(object: $0) }
        var mapboxRoutes = [Route]()
        
        for string in routePartStrings {
            guard let string = string else { return }
            
            convertHypervisorPartToMapboxRoute(routePartString: string) { route in
                guard let route = route else {
                    return
                }
                mapboxRoutes.append(route)
                
                if string == routePartStrings.last {
                    let mapboxRoutesString = self.convertObjectToJsonString(object: mapboxRoutes)
                    print("mapboxRoutesString: \(mapboxRoutesString)")
                }
            }
        }
        
    }
    
    private func convertJsonStringToObject<T: Decodable>(jsonString: String) -> T? {
        do {
            let jsonData: Data = Data(jsonString.utf8)
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            print("method: convertJsonStringToObject, failed to decode jsonString to object, error: \(error)")
            return nil
        }
    }
    
    private func convertJsonStringToMapboxRoute(jsonString: String) -> Route? {
        do {
            let data: Data = Data(jsonString.utf8)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            print("json: \(String(describing: json))")
            let legs = json!["legs"] as? [Any]
            let firstLeg = legs?.first as? [String: Any]
            let source = firstLeg?["source"]  as? [String: Any]
            let destination = firstLeg?["destination"]  as? [String: Any]
            guard let sourceLocation = source?["location"] as? [Double], let destinationLocation = destination?["location"] as? [Double] else { return nil }
            let coordinates: [[Double]] = [sourceLocation, destinationLocation]
            let waypoints: [Waypoint] = coordinates.map({ coors in
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: coors[0], longitude: coors[1]))
            })
            let routeOptions = RouteOptions(waypoints: waypoints)
            
            let decoder = JSONDecoder()
            decoder.userInfo[.options] = routeOptions
            
            let object = try? decoder.decode(Route.self, from: data)
            return object
        } catch {
            print("convertJsonStringToObject, error: \(error)")
            return nil
        }
    }
    
    private func convertObjectToJsonString<T: Encodable>(object: T) -> String? {
        do {
            let jsonData = try JSONEncoder().encode(object)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
