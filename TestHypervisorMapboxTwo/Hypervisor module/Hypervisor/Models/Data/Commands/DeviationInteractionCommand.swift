//
//  DeviationInteractionCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Deviation command to send the deviated location to the websocket
/// - message: Message containing the route deviation info
class DeviationInteractionCommand: BaseInteractionCommand<DeviatedLocationMessage> {
    init(routeId: String, message: DeviatedLocationMessage) {
        super.init(command: .deviation, tripId: routeId, message: message)
    }
}
