//
//  StartPartInteractionCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Start command to initialise a start of a part of the route to the websocket
/// - message: Message containing the part of the route that is being updated
class StartPartInteractionCommand: BaseInteractionCommand<PartUpdateMessage> {
    init(tripId: String, message: PartUpdateMessage) {
        super.init(command: .startPart, tripId: tripId, message: message)
    }
}
