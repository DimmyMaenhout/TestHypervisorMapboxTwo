//
//  InfeasibilityReasons.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 10/02/2021.
//

/// Infeasibility reasons
public enum InfeasibilityReason: String, Decodable {
    case
        unknown = "unknown",
        cancelledPart = "cancelled_part",
        insufficientTransferTime = "insufficient_transfer_time"
}
