//
//  DeviatedLocationMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

import HypervisorCore

/// Location message to sent the location to the websocket
class DeviatedLocationMessage: BaseLocationMessage {
    /// Location object containing the information of the location where the user deviated of the route
    let deviation: Location
    
    /// A wkt geo formatted string of the trip
    let geo: String
    
    private enum CodingKeys: String, CodingKey {
        case
            deviation = "deviatedLocation",
            geo
    }
    
    init(location: Location, deviation: Location, geo: String) {
        self.deviation = deviation
        self.geo = geo
        super.init(location: location)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deviation, forKey: .deviation)
        try container.encode(geo, forKey: .geo)
        try super.encode(to: encoder)
    }
}
