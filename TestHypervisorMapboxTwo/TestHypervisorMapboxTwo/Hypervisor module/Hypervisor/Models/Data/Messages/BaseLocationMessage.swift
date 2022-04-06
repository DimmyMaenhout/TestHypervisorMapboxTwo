//
//  BaseLocationMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

//import HypervisorCore

/// Location message to sent the location to the websocket
class BaseLocationMessage: Encodable {
    /// Location object containing the information of the location of the user
    let location: Location
    
    private enum CodingKeys: String, CodingKey {
        case location
    }
    
    init(location: Location) {
        self.location = location
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: .location)
    }
}
