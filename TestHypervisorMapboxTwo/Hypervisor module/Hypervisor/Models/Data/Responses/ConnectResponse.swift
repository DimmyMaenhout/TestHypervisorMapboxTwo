//
//  ConnectResponse.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Connection response of the websocket
class ConnectResponse: Decodable {
    let command: CommandStates
    let timestamp: String?
    let success: Bool?
    let message: ResponseMessage

    private enum CodingKeys: String, CodingKey {
        case
            command,
            timestamp,
            success,
            message
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        command = try container.decode(CommandStates.self, forKey: .command)
        timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        message = try container.decode(ResponseMessage.self, forKey: .message)
    }
}
