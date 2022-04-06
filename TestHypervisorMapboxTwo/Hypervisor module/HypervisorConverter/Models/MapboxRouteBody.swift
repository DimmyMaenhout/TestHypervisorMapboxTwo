//
//  MapboxRouteBody.swift
//  HypervisorConverter
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

//import HypervisorCore

/// Mapbox body object for the post call towards the conversion api.
public struct MapboxRouteBody: Encodable {
    
    /// Mapbox config object for configuring the mapbox route.
    public let mapboxConfig: MapboxConfig
    
    /// part that needs to be converted
    public let routePart: RoutePart
}
