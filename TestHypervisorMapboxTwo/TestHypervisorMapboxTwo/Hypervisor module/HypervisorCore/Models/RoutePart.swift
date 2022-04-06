//
//  RoutePart.swift
//  HypervisorCore
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

import GEOSwift
import CoreLocation.CLLocation

/// A part of the (multi-modal) trip
public struct RoutePart: Codable, Equatable {
    
    /// Visual representation of the route to be followed in this leg in a wkt string format
    public let geo: String
    
    /// GEOSwift.LineString based on the `geo` property's WKT string
    public func makeLineString() -> LineString? {
        try? LineString(wkt: geo)
    }
    
    func makePointArray() -> [Point] {
        makeLineString()?.points ?? []
    }
    
    /// The mode used in this part of the route
    public let mode: TransferType
    
    /// Length of the leg (in m)
    public let distance: CLLocationDistance
    
    /// More detailed information related to the specific mode used
    public let publicTransportInfo: PublicTransportInfo?
    
    public let sharedMobilityInfo: SharedMobilityInfo?
    
    /// Arrival time of the leg
    public let arrivalTime: String
    
    ///  Departure time of the leg
    public let departureTime: String
    
    public init(geo: String, mode: TransferType, distance: CLLocationDistance, publicTransportInfo: PublicTransportInfo?, sharedMobilityInfo:  SharedMobilityInfo?, arrivalTime: String, departureTime: String) {
        self.geo = geo
        self.mode = mode
        self.distance = distance
        self.publicTransportInfo = publicTransportInfo
        self.sharedMobilityInfo = sharedMobilityInfo
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
    }
}
