//
//  PartUpdateMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Message to update a part of the route
struct PartUpdateMessage: Encodable {
    /// Update object containig the part id that it needs to update to
    let partUpdate: Update
}
