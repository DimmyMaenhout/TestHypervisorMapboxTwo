//
//  PublicTransportStopInfo.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Public Transport info
public struct PublicTransportStopInfo {
    /// Stop type
    public let type: PublicTransportStopTypes
    
    /// Info
    public let info: [PublicTransportNotificationInfo]
}
