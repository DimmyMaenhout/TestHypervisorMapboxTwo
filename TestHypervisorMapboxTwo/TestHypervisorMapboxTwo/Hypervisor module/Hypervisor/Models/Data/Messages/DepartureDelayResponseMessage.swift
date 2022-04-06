//
//  DepartureDelayResponseMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Departure delay response message from websocket
class DepartureDelayResponseMessage: BaseResponseMessage {
    /// Departure delay in milliseconds
    let departureDelayMs: Int
    
    private enum CodingKeys: String, CodingKey {
        case
            departureDelayMs
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        departureDelayMs = try container.decode(Int.self, forKey: .departureDelayMs)
        try super.init(from: decoder)
    }
}
