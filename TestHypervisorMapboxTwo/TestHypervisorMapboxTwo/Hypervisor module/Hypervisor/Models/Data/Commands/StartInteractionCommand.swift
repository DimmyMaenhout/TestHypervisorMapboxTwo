//
//  StartInteractionCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Start command to initialise a start of the route to the websocket
class StartInteractionCommand: BaseInteractionCommand<[String: String]> {
    init(tripId: String) {
        super.init(command: .start, tripId: tripId, message: [:])
    }
}
