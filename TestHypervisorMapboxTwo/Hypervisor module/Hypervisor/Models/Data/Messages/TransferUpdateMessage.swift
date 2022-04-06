//
//  TransferUpdateMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Response message
struct TransferUpdateMessage: Encodable {
    /// The part of the route that needs a transfer
    let transferUpdate: TransferUpdate
}
