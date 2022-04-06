//
//  Stop.swift
//  HypervisorCore
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

/// More detailed information of a public transport stop
public struct Stop: Codable, Equatable {
    
    /// Name of the street
    public let name: String
    
    /// Id of the specific stop
    public let stopId: String
    
    /// Time of departure formatted yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
    ///
    /// Format is part of ISO-8601.
    public let departureTime: String
    
    /// arrivalTime Time of arrival formatted yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
    public let arrivalTime: String
    
    public init(name: String, stopId: String, departureTime: String, arrivalTime: String) {
        self.name = name
        self.stopId = stopId
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
    }
}
