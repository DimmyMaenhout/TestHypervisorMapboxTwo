//
//  StopInteractionCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Stop command to initialise a stop of the route to the websocket
class StopInteractionCommand: BaseInteractionCommand<[String: String]> {
    init(tripId: String) {
        super.init(command: .stop, tripId: tripId, message: [:])
    }
}
