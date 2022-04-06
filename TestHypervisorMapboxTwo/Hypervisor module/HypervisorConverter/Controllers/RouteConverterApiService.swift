//
//  RouteConverterApiService.swift
//  HypervisorConverter
//
//  Created by Maarten Zonneveld on 11/02/2021.
//

import Foundation

/// Converter api service containing all the route converter calls.
public class RouteConverterApiService {
    
    public enum BaseURL: String, CaseIterable {
        case beta
        case production
        
        var url: URL {
            switch self {
            case .production: return URL(string: "https://routing.be-mobile.io/guidance/mapbox/route-part-converter/v1/")!
            case .beta: return URL(string: "https://routing-staging.be-mobile.io/guidance/route-part-to-mapbox/beta/")!
            }
        }
    }
    
    static private let convertRouteUrlPath = "convert"
    static private let beMobileApiKeyHeader = "be-mobile-api-key"
    static public var baseURL = BaseURL.beta
    
    func convertRoute(apikey: String, mapboxRouteBody: MapboxRouteBody, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        let httpBody: Data
        do {
            httpBody = try JSONEncoder().encode(mapboxRouteBody)
        } catch {
            completion(nil, error)
            return
        }
        
        var request = URLRequest(
            url: Self.baseURL.url.appendingPathComponent(Self.convertRouteUrlPath),
            httpMethod: "POST",
            httpBody: httpBody
        )
        request.setValue(apikey, forHTTPHeaderField: Self.beMobileApiKeyHeader)
        
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(data, nil)
        }
        .resume()
    }
}
