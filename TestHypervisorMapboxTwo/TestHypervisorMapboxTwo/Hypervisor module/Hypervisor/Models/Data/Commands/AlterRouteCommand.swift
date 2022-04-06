//
//  AlterRouteCommand.swift
//  Hypervisor
//
//  Created by Frans FM on 10/11/2021.
//

import Foundation

class AlterRouteCommand: BaseInteractionCommand<Alternative> {
    init(_ message: Alternative, _ routeId: String) {
        super.init(command: .alterRoute, tripId: routeId, message: message)
    }
}
