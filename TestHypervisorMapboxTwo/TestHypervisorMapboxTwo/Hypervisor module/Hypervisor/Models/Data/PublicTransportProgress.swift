//
//  PublicTransportProgress.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Progress Public Transport message from websocket
struct PublicTransportProgress: Decodable {
    /// Type
    let type: String
    
    /// Progress public transport stops
    let progressPublicTransportStops: [PublicTransportNotificationInfo]
    
    private enum CodingKeys: String, CodingKey {
        case
            type = "@type",
            progressPublicTransportStops
    }
}
