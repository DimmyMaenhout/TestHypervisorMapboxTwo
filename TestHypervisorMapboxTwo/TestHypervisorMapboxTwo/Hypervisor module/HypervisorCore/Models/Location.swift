//
//  Location.swift
//  HypervisorCore
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

/// Type to save specific points containing a latitude and longitude.
public struct Location: Codable, Equatable {
    
    public let version: String
    
    public let providerId: Int
    
    public let dateTime: String
    
    /// The latitude of the specific point.
    public let latitude: Double
    
    /// The longitude of the specific point.
    public let longitude: Double
    
    public let speedKmH: Int
    
    public let heading: Int
    
    public let receivedDate: String
    
    public let vehicleId: String
    
    public init(version: String, providerId: Int, dateTime: String, latitude: Double, longitude: Double, speedKmH: Int, heading: Int, receivedDate: String, vehicleId: String) {
        self.version = version
        self.providerId = providerId
        self.dateTime = dateTime
        self.latitude = latitude
        self.longitude = longitude
        self.speedKmH = speedKmH
        self.heading = heading
        self.receivedDate = receivedDate
        self.vehicleId = vehicleId
    }
}
