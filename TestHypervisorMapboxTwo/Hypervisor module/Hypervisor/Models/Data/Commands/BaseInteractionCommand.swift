//
//  BaseInteractionCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Base interaction command class containing the Basecommand and message type which can be any object
class BaseInteractionCommand<T: Encodable>: BaseCommand {
    /// Id of the trip
    let tripId: String
    
    /// Message which is being sent by the command
    let message: T
    
    private enum CodingKeys: String, CodingKey {
        case
            tripId = "id",
            message = "p"
    }
    
    init(
        command: CommandStates,
        tripId: String,
        message: T)
    {
        self.tripId = tripId
        self.message = message
        super.init(command: command)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tripId, forKey: .tripId)
        try container.encode(message, forKey: .message)
        try super.encode(to: encoder)
    }
}
