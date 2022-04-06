//
//  TransferType+Extensions.swift
//  HypervisorConverter
//
//  Created by Maarten Zonneveld on 16/02/2021.
//

import HypervisorCore

public extension TransferType {
    
    func toMapboxProfile() -> String {
        switch self {
        case .car, .sharedCar, .taxi, .moped, .sharedMoped, .truck: return "mapbox/driving-traffic"
        case .bike, .ebike, .foldableBike, .sharedBike, .scooter, .sharedScooter, .pedelec, .segway: return "mapbox/cycling"
        case .foot: return "mapbox/walking"
        case .train, .transfer, .metro, .ferry, .tram, .bus: return "" // Currently not supported
        }
    }
}
