//
//  StartTransferInteractionCommand.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Start of a transfer command to initialise a transfer to the websocket
/// - message: Message containing the update on the transfer
class StartTransferInteractionCommand: BaseInteractionCommand<TransferUpdateMessage> {
    init(tripId: String, message: TransferUpdateMessage) {
        super.init(command: .startTransfer, tripId: tripId, message: message)
    }
}
