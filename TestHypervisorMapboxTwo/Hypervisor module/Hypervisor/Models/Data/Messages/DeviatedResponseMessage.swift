//
//  DeviatedResponseMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

import CoreLocation.CLLocation

/// Location message response from websocket
class DeviatedResponseMessage: BaseResponseMessage {
    /// A wkt geo formatted string
    let geo: String
    
    /// Departure time
    let departureTime: String
    
    /// Arrival time
    let arrivalTime: String
    
    /// Distance
    let distance: CLLocationDistance
    
    private enum CodingKeys: String, CodingKey {
        case
            geo,
            departureTime,
            arrivalTime,
            distance
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        geo = try container.decode(String.self, forKey: .geo)
        departureTime = try container.decode(String.self, forKey: .departureTime)
        arrivalTime = try container.decode(String.self, forKey: .arrivalTime)
        distance = try container.decode(CLLocationDistance.self, forKey: .distance)
        try super.init(from: decoder)
    }
}
