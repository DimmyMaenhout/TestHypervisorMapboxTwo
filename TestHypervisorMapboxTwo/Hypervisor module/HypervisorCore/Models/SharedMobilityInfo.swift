//
//  SharedMobilityInfo.swift
//  HypervisorCore
//
//  Created by Frans FM on 10/11/2021.
//

import Foundation

public struct SharedMobilityInfo: Codable, Equatable {
    var provider: HypervisorSharedMobilityAgency?
    var exitId: String?
    var entranceId: String?
    var isElectrified: Bool?
    var batteryLevel: Double?
    
    public init(provider: HypervisorSharedMobilityAgency? = nil, exitId: String? = nil, entranceId: String? = nil, isElectrified: Bool? = nil, batteryLevel: Double? = nil) {
        self.provider = provider
        self.exitId = exitId
        self.entranceId = entranceId
        self.isElectrified = isElectrified
        self.batteryLevel = batteryLevel
    }
}
