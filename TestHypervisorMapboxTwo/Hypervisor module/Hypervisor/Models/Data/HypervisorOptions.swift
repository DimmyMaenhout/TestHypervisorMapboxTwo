//
//  HypervisorOptions.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

//import HypervisorCore
import Foundation 
/// Hypervisor options
public struct HypervisorOptions {
    
    public let intervalTime: TimeInterval
    public let intervalTimeAtDestination: TimeInterval
    public let intervalTimeAtDeviation: TimeInterval
    public let userDestinationRadius: Int
    public let deviationTolerance: Double
    public let destinationReachedRadius: Int
    public let endOfLegRadius: Int
    public let autoStartPart: Bool
    public let alternativeRoutesAmount: Int
    public let carDelayPercentage: Int
    public let alternativeModi: AlternativeRouteModiOption
    public let allowedTransferTypes: [TransferType]
    public let selectedSharedMobilityProviders: [HypervisorSharedMobilityAgency]
    
    public init(
        intervalTime: TimeInterval = 15,
        intervalTimeAtDestination: TimeInterval = 5,
        intervalTimeAtDeviation: TimeInterval = 5,
        userDestinationRadius: Int = 250,
        deviationTolerance: Double = 30.0,
        destinationReachedRadius: Int = 10,
        endOfLegRadius: Int = 250,
        autoStartPart: Bool = true,
        alternativeRoutesAmount: Int = 3,
        carDelayPercentage: Int = 5,
        alternativeModi: AlternativeRouteModiOption = .currentModi,
        selectedModi: [TransferType] = [],
        selectedSharedMobilityProviders: [HypervisorSharedMobilityAgency] = []) {
        
        self.intervalTime = intervalTime
        self.intervalTimeAtDestination = intervalTimeAtDestination
        self.intervalTimeAtDeviation = intervalTimeAtDeviation
        self.userDestinationRadius = userDestinationRadius
        self.deviationTolerance = deviationTolerance
        self.destinationReachedRadius = destinationReachedRadius
        self.endOfLegRadius = endOfLegRadius
        self.autoStartPart = autoStartPart
        self.alternativeRoutesAmount = alternativeRoutesAmount
        self.carDelayPercentage = carDelayPercentage
        self.alternativeModi = alternativeModi
        self.allowedTransferTypes = selectedModi
        self.selectedSharedMobilityProviders = selectedSharedMobilityProviders
    }
}

public enum AlternativeRouteModiOption: String, Codable {
    case
        currentModi = "current_modi",
        selectedModi = "selected_modi",
        allModi = "all_modi"
}
