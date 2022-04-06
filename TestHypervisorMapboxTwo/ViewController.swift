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
    
    private let hrPart = "{\"arrivalTime\": \"2021-12-09T10:44:56.291Z\", \"departureTime\": \"2021-12-09T10:35:24.000Z\", \"distance\": 5596.4, \"geo\": \"LINESTRING (4.37533 51.14052, 4.37535 51.14083, 4.37545 51.14119, 4.37554 51.14156, 4.37604 51.14158, 4.37654 51.14159, 4.37704 51.14161, 4.37755 51.14162, 4.37767 51.14201, 4.37778 51.14239, 4.37836 51.14241, 4.37893 51.14244, 4.37926 51.14244, 4.37943 51.14244, 4.37958 51.14244, 4.38022 51.14243, 4.38085 51.14243, 4.38155 51.1425, 4.38223 51.14261, 4.38291 51.14273, 4.38358 51.14284, 4.38426 51.14295, 4.38494 51.14307, 4.38562 51.14318, 4.3863 51.14329, 4.38698 51.14341, 4.38766 51.14352, 4.38833 51.14365, 4.38898 51.14382, 4.38961 51.14401, 4.39023 51.14422, 4.39047 51.14429, 4.39108 51.14445, 4.39172 51.14454, 4.39238 51.14459, 4.39303 51.14464, 4.39369 51.14468, 4.39435 51.14473, 4.39501 51.14478, 4.39567 51.1448, 4.39614 51.14476, 4.39661 51.14469, 4.39708 51.14462, 4.39775 51.14452, 4.39842 51.14442, 4.39909 51.14432, 4.39977 51.14424, 4.40045 51.14419, 4.40114 51.14417, 4.40183 51.14416, 4.40252 51.14415, 4.40321 51.14414, 4.4039 51.14413, 4.40458 51.14412, 4.40525 51.1441, 4.40591 51.14409, 4.40657 51.14408, 4.40723 51.14404, 4.40787 51.14395, 4.40851 51.14385, 4.40867 51.14382, 4.40917 51.14373, 4.40967 51.14364, 4.41034 51.14353, 4.411 51.14342, 4.41167 51.1433, 4.41233 51.14319, 4.41298 51.14304, 4.41361 51.14288, 4.41425 51.14271, 4.41488 51.14254, 4.4155 51.14236, 4.41613 51.14219, 4.41676 51.14202, 4.41738 51.14185, 4.41801 51.14167, 4.41863 51.1415, 4.41926 51.14133, 4.41989 51.14116, 4.42051 51.14099, 4.42114 51.14082, 4.42177 51.14065, 4.42239 51.14048, 4.42302 51.14031, 4.42364 51.14014, 4.4243 51.14002, 4.42448 51.14, 4.42517 51.13992, 4.42586 51.13985, 4.42656 51.13977, 4.42725 51.13969, 4.42795 51.13962, 4.42864 51.13954, 4.42922 51.13948, 4.42981 51.13941, 4.43039 51.13935, 4.4309 51.13929, 4.43142 51.13923, 4.43194 51.13918, 4.43263 51.13909, 4.43331 51.13899, 4.43386 51.1389, 4.43437 51.13876, 4.43489 51.13862, 4.4355 51.13845, 4.43611 51.13829, 4.43672 51.13813, 4.43703 51.13804, 4.43731 51.13797, 4.43783 51.13784, 4.43837 51.13771, 4.4389 51.13757, 4.43915 51.13749, 4.43901 51.13789, 4.43887 51.13829, 4.43874 51.13869, 4.4386 51.13909, 4.43847 51.13949, 4.43833 51.13988, 4.4382 51.14028, 4.43888 51.14028, 4.43955 51.14026, 4.43979 51.14026, 4.44017 51.14025, 4.44056 51.14024, 4.44123 51.14022, 4.44136 51.1405, 4.44141 51.14061, 4.44157 51.14097, 4.44173 51.14132, 4.44177 51.14143, 4.44189 51.14168, 4.442 51.14192, 4.44208 51.14209, 4.4416 51.14208)\", \"mode\": \"car\"}"
    
    private let hrPartTwo = "{\"arrivalTime\": \"2021-12-09T10:44:56.291Z\", \"departureTime\": \"2021-12-09T10:35:24.000Z\", \"distance\": 5596.4, \"geo\": \"LINESTRING (4.37533 51.14052, 4.37535 51.14083, 4.37545 51.14119, 4.37554 51.14156, 4.37604 51.14158, 4.37654 51.14159, 4.37704 51.14161, 4.37755 51.14162, 4.37767 51.14201, 4.37778 51.14239, 4.37836 51.14241, 4.37893 51.14244, 4.37926 51.14244, 4.37943 51.14244, 4.37958 51.14244, 4.38022 51.14243, 4.38085 51.14243, 4.38155 51.1425, 4.38223 51.14261, 4.38291 51.14273, 4.38358 51.14284, 4.38426 51.14295, 4.38494 51.14307, 4.38562 51.14318, 4.3863 51.14329, 4.38698 51.14341, 4.38766 51.14352, 4.38833 51.14365, 4.38898 51.14382, 4.38961 51.14401, 4.39023 51.14422, 4.39047 51.14429, 4.39108 51.14445, 4.39172 51.14454, 4.39238 51.14459, 4.39303 51.14464, 4.39369 51.14468, 4.39435 51.14473, 4.39501 51.14478, 4.39567 51.1448, 4.39614 51.14476, 4.39661 51.14469, 4.39708 51.14462, 4.39775 51.14452, 4.39842 51.14442, 4.39909 51.14432, 4.39977 51.14424, 4.40045 51.14419, 4.40114 51.14417, 4.40183 51.14416, 4.40252 51.14415, 4.40321 51.14414, 4.4039 51.14413, 4.40458 51.14412, 4.40525 51.1441, 4.40591 51.14409, 4.40657 51.14408, 4.40723 51.14404, 4.40787 51.14395, 4.40851 51.14385, 4.40867 51.14382, 4.40917 51.14373, 4.40967 51.14364, 4.41034 51.14353, 4.411 51.14342, 4.41167 51.1433, 4.41233 51.14319, 4.41298 51.14304, 4.41361 51.14288, 4.41425 51.14271, 4.41488 51.14254, 4.4155 51.14236, 4.41613 51.14219, 4.41676 51.14202, 4.41738 51.14185, 4.41801 51.14167, 4.41863 51.1415, 4.41926 51.14133, 4.41989 51.14116, 4.42051 51.14099, 4.42114 51.14082, 4.42177 51.14065, 4.42239 51.14048, 4.42302 51.14031, 4.42364 51.14014, 4.4243 51.14002, 4.42448 51.14, 4.42517 51.13992, 4.42586 51.13985, 4.42656 51.13977, 4.42725 51.13969, 4.42795 51.13962, 4.42864 51.13954, 4.42922 51.13948, 4.42981 51.13941)\", \"mode\": \"car\"}"
    
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
    
            startNavigationFromHypervisorRoute()
        }
    
        // MARK: - Private methods
    
        private func setupMapView() {
            navigationMapView = NavigationMapView(frame: view.bounds)
            navigationMapView?.delegate = self
            navigationMapView.navigationMapViewDelegate = self
            navigationMapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
            navigationMapView.showsUserLocation = false
            self.navigationMapView.tracksUserCourse = false
    
            view.addSubview(navigationMapView)
        }
    
    private func startNavigationFromHypervisorRoute() {
        convertHypervisorPartToMapboxRoute(routePartString: hrPart) { [weak self] route in
            guard let route = route, let self = self else {
                print("Route was nil")
                return
            }
            
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
            
            let routeOptions = NavigationRouteOptions(waypoints: [
                Waypoint(coordinate: origin),
                Waypoint(coordinate: destination)
            ])
            
            //            let routeOptions = NavigationRouteOptions(
            //                waypoints: [
            //                    Waypoint(coordinate: origin),
            //                    Waypoint(coordinate: destination)])//RouteOptions(matchOptions: matchOptions)
            
            //            let simulatedLocationManager = SimulatedLocationManager(route: route)
            //            simulatedLocationManager.speedMultiplier = 1
            
            let routeResponse = RouteResponse(
                httpResponse: nil,
                identifier: "id",
                routes: [route],
                waypoints: waypoints,
                options: .route(routeOptions),
                credentials: directions.credentials)
            
            let navService = MapboxNavigationService(route: route, routeOptions: routeOptions, directions: directions, locationSource: nil, eventsManagerType: nil, simulating: .always, routerType: nil)
            
            self.navService = navService
            self.navService?.delegate = self
            
//            self.voiceController = RouteVoiceController(navigationService: navService)
                        
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                self.navigationMapView.userTrackingMode = .followWithHeading
                self.navigationMapView.tracksUserCourse = true
                
                self.navService?.start()
                
                self.navigationMapView.showcase([route])
                
                self.navigationMapView.updateCourseTracking(location: CLLocation(latitude: origin.latitude, longitude: origin.longitude))
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
}

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
        navigationMapView.updateCourseTracking(location: location, animated: true)
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

extension ViewController: MGLMapViewDelegate {
    
}

extension ViewController: NavigationMapViewDelegate {
    
}

extension ViewController {
    private func convertJsonStringToObject<T: Decodable>(jsonString: String) -> T? {
        do {
            let jsonData: Data = Data(jsonString.utf8)
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            print("method: convertJsonStringToObject, failed to decode jsonString to object, error: \(error)")
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
