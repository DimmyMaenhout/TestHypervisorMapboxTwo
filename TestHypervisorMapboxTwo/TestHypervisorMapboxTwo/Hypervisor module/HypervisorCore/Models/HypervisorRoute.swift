//
//  HypervisorRoute.swift
//  HypervisorCore
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

import GEOSwift
import CoreLocation.CLLocation

/// A (multi-modal) trip containing all the details of the route.
public struct HypervisorRoute: Codable, Equatable {
    
    /// Different parts of the (multi-modal) trip.
    public let parts: [RoutePart]
    
    public init(parts: [RoutePart]) {
        self.parts = parts
    }
    
    /// Gets the total distance
    public var totalDistance: CLLocationDistance {
        parts
            .map { $0.distance }
            .reduce(0, +)
    }
    
    public func makePointArray() -> [Point] {
        parts
            .map { $0.makePointArray() }
            .joined()
            .toArray()
    }
    
    public func makeFullRouteLineString() throws -> LineString {
        try LineString(points: makePointArray())
    }
}
