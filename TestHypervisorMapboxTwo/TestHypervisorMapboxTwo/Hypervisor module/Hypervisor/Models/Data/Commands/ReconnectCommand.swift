//
//  ReconnectCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Reconnect command to reconnect to the websocket
class ReconnectCommand: BaseCommand {
    /// Id that is given when connecting to the websocket
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case
            id
    }
    
    init(id: String, timestamp: String) {
        self.id = id
        super.init(command: .reconnect, timestamp: timestamp)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try super.encode(to: encoder)
    }
}
