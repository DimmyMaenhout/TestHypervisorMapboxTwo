//
//  PublicTransportNotificationInfo.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Public Transport info
public struct PublicTransportNotificationInfo: Decodable {
    /// Name of stop
    public let stopName: String
    
    /// Stop id
    public let stopId: String
    
    /// Is current stop
    public let isCurrentStop: Bool
    
    /// Stop platform code
    public let stopPlatformCode: String?
    
    /// Static departure time
    public let staticDepartureTime: String
    
    /// Static arrival time
    public let staticArrivalTime: String
    
    /// Realtime departure time
    public let realTimeDepartureTime: String?
    
    /// Realtime arrival time
    public let realTimeArrivalTime: String?
    
    /// Departure delay in milliseconds
    public let departureDelayMs: Int
    
    /// Arrival delay in milliseconds
    public let arrivalDelayMs: Int
}
