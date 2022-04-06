//
//  BaseCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Base command class containing the command type and timestamp. This class is needed for all the commands of the websocket
class BaseCommand: Encodable {
    /// Type of command that is being used
    var command: CommandStates
    
    /// Timestamp of the command
    var timestamp: String?
    
    /// Success
    var success: Bool?
    
    /// Error
    var error: HypervisorError?
    
    private enum CodingKeys: String, CodingKey {
        case
            command,
            timestamp,
            success,
            error
    }
    
    init(
        command: CommandStates,
        timestamp: String? = nil,
        success: Bool? = nil,
        error: HypervisorError? = nil)
    {
        self.command = command
        self.timestamp = timestamp
        self.success = success
        self.error = error
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(command, forKey: .command)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(success, forKey: .success)
        try container.encode(error, forKey: .error)
    }
}
