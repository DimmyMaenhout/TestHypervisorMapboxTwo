//
//  ConnectCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Connection command to connect to the websocket
class ConnectCommand: BaseCommand {
    init(timestamp: String) {
        super.init(command: .connect, timestamp: timestamp)
    }
}
