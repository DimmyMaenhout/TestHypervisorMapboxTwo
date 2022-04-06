//
//  TransferUpdateResponseMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Transfer update message from websocket
class TransferUpdateResponseMessage: BaseResponseMessage {
    /// Public transport notification info
    let transferUpdatePublicTransportStop: PublicTransportNotificationInfo
    
    private enum CodingKeys: String, CodingKey {
        case
            transferUpdatePublicTransportStop
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transferUpdatePublicTransportStop = try container.decode(PublicTransportNotificationInfo.self, forKey: .transferUpdatePublicTransportStop)
        try super.init(from: decoder)
    }
}
