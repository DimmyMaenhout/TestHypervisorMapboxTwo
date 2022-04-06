
//import HypervisorCore
import Foundation

private let logTag = "HypervisorConverter"

//internal func log(_ level: LogLevel, _ message: String) {
//    HypervisorCoreController.logger?.log(level, logTag, message)
//}

public class HypervisorConverter {
    
    /// Function for converting a hypervisor part towards a mapbox route json
    /// - Parameters:
    ///   - apikey: Be-Mobile API key.
    ///   - routePart: Route that needs to be converted.
    ///   - mapboxConfig: Config for configuring the mapbox route. i.e. steps and language.
    public static func convertHypervisorPartToMapBoxRoute(apikey: String, routePart: RoutePart, mapboxConfig: MapboxConfig, completion: @escaping (_ data: Data?) -> Void) {
        
        let functionTag = "convertHypervisorPartToMapBoxRoute"
        
        RouteConverterApiService().convertRoute(apikey: apikey, mapboxRouteBody: .init(mapboxConfig: mapboxConfig, routePart: routePart), completion: { data, error in
            
            if let error = error {
                log(.error, "\(functionTag) - error: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                log(.error, "\(functionTag) - error: no response data")
                completion(nil)
                return
            }
            
            log(.info, "\(functionTag) - success: fetched route data")
            completion(data)
        })
    }
}
