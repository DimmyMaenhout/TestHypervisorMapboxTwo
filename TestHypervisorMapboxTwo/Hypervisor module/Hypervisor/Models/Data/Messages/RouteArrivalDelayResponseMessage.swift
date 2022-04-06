//
//  RouteArrivalDelayResponseMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Route arrival delay response message
class RouteArrivalDelayResponseMessage: BaseResponseMessage {
    /// Delay in milliseconds
    let delayMs: Int
    
    private enum CodingKeys: String, CodingKey {
        case
            delayMs
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        delayMs = try container.decode(Int.self, forKey: .delayMs)
        try super.init(from: decoder)
    }
}
