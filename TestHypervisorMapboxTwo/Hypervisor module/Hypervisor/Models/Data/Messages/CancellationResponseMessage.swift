//
//  CancellationResponseMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Cancelled Public Transport message from websocket
class CancellationResponseMessage: BaseResponseMessage {
    /// Cancelled public transport stop
    let cancelledPublicTransportStop: PublicTransportNotificationInfo
    
    private enum CodingKeys: String, CodingKey {
        case
            cancelledPublicTransportStop
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cancelledPublicTransportStop = try container.decode(PublicTransportNotificationInfo.self, forKey: .cancelledPublicTransportStop)
        try super.init(from: decoder)
    }
}
