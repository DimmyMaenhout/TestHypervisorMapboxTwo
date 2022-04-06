//
//  InitInteractionCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Initialisation command to initialise the route to the websocket
/// - message: Message containing the route info
class InitInteractionCommand: BaseInteractionCommand<RouteInfoMessage> {
    init(routeId: String, message: RouteInfoMessage) {
        super.init(command: .initialize, tripId: routeId, message: message)
    }
}
