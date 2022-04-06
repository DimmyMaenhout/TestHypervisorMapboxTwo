//
//  UpdateLocationInteractionCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Update location command to send the location to the websocket
/// - message: Message containing the location of the user
class UpdateLocationInteractionCommand: BaseInteractionCommand<LocationMessage> {
    init(tripId: String, message: LocationMessage) {
        super.init(command: .updateLocation, tripId: tripId, message: message)
    }
}
