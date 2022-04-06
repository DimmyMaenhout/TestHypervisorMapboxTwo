//
//  ArrivalDelayResponseMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Arrival delay response message from websocket
class ArrivalDelayResponseMessage: BaseResponseMessage {
    /// Arrival delay in milliseconds
    let arrivalDelayMs: Int
    
    private enum CodingKeys: String, CodingKey {
        case
            arrivalDelayMs
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        arrivalDelayMs = try container.decode(Int.self, forKey: .arrivalDelayMs)
        try super.init(from: decoder)
    }
}
