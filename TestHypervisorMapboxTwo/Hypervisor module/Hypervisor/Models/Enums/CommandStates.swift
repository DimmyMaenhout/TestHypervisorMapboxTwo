//
//  CommandStates.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 10/02/2021.
//

/// Enum to describe the different command types for websocket connection
enum CommandStates: String, Codable {
    case
        connect = "CONNECT",
        reconnect = "RECONNECT",
        start = "START",
        stop = "STOP",
        startPart = "STARTPART",
        startTransfer = "STARTTRANSFER",
        updateLocation = "UPDATELOCATION",
        deviation = "DEVIATION",
        initialize = "INIT",
        alterRoute = "ALTERROUTE"
}
