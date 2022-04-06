//
//  BaseResponse.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 15/02/2021.
//

/// Base response
class BaseResponse<T: Decodable>: Decodable {
    /// Generic message, so can be different kind of types
    let message: T
    
    /// Part id
    let partId: Int
    
    /// Transfer id
    let transferId: Int
    
    /// Event type
    let type: EventTypes
    
    private enum CodingKeys: String, CodingKey {
        case
            message = "event",
            partId,
            transferId,
            type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(T.self, forKey: .message)
        partId = try container.decode(Int.self, forKey: .partId)
        transferId = try container.decode(Int.self, forKey: .transferId)
        type = try container.decode(EventTypes.self, forKey: .type)
    }
}
