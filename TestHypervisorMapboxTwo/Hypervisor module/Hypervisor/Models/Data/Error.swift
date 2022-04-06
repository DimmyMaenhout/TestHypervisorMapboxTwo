//
//  Error.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Error class for handling the errors of the websocket
class HypervisorError: Codable {
    /// Error code of the error
    let code: String
    
    /// Title of the error
    let title: String
    
    /// Description of the error
    let detail: String
}
