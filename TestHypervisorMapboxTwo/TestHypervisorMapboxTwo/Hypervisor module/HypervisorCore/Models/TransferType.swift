//
//  TransferType.swift
//  HypervisorCore
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

/// Enum to describe the different transfer types
@frozen public enum TransferType: String, Codable, Equatable, CaseIterable {
    case
    car,
    bike,
    ebike,
    foldableBike,
    foot,
    taxi,
    bus,
    train,
    metro,
    tram,
    ferry,
    
    transfer,
    segway,
    moped,
    truck,
    pedelec,
    scooter,
        
    sharedCar,
    sharedBike,
    sharedMoped,
    sharedScooter
}
