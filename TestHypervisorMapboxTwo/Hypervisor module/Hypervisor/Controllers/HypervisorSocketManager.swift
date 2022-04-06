//
//  HypervisorSocketManager.swift
//  Hypervisor
//
//  Created by Maarten Zonneveld on 19/02/2021.
//

import Starscream
//import HypervisorCore

protocol HypervisorSocketManagerDelegate: AnyObject {
    
    /// Invoked when the websocket is connected
    func onConnected()
    
    /// Invoked when a websocket error occurs
    func onFailed(error: Error?)
    
    /// Invoked when the websocket is disconnected
    func onClose()
    
    /// Invoked whenever a new message is received through the websocket
    func onMessage(message: String)
}

/// Manager used to manage the socket connection between the api and events in Hypervisor.
final class HypervisorSocketManager {
    
    private static let logTag = "[HypervisorSocketManager]"
    
    private(set) var isConnected = false {
        didSet {
            isConnected ? delegate?.onConnected() : delegate?.onClose()
        }
    }
    
    /// The currently used websocket
    private var socket: WebSocket?
    
    /// The message callback for websocket messages and websocket connection states
    private weak var delegate: HypervisorSocketManagerDelegate?
    
    init(delegate: HypervisorSocketManagerDelegate) {
        self.delegate = delegate
    }
    
    /// Connects a websocket to the given URL
    func connect(url: URL) {
        socket?.forceDisconnect()
        socket = nil
        
        let request = URLRequest(url: url)
        let socket = WebSocket(request: request)
        socket.respondToPingWithPong = true
        socket.delegate = self
        self.socket = socket
        socket.connect()
    }
    
    func forceDisconnect() {
        socket?.forceDisconnect()
        socket = nil
    }
    
    /// Disconnects the websocket
    /// - Parameter reason: An optional custom reason why this websocket is being disconnected.
    func disconnect(reason: String?) {
        log(.info, "\(Self.logTag) Websocket disconnected manually. Reason: \(reason)")
        socket?.disconnect(closeCode: CloseCode.normal.rawValue)
    }
    
    /// Sends a message through the websocket
    func sendMessage<T: Encodable>(_ encodable: T, completion: (() -> Void)? = nil) {
        let jsonData: Data
        do {
            jsonData = try JSONEncoder().encode(encodable)
        } catch {
            log(.error, "Could not encode message. Object: \(encodable)")
            assertionFailure()
            completion?()
            return
        }
        log(.info, "\(Self.logTag) Writing to socket. Type: \(type(of: encodable)).")
        socket?.write(data: jsonData, completion: completion)
    }
    
    /// Sends a message through the websocket
    func sendMessage(_ data: Data, completion: (() -> Void)? = nil) {
        log(.info, "\(Self.logTag) Writing to socket. Bytes: \(data.count).")
        socket?.write(data: data, completion: completion)
    }
}

extension HypervisorSocketManager: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            log(.info, "\(Self.logTag) - socket connected. Headers: \(headers)")
            isConnected = true
            
        case .disconnected(let reason, let code):
            log(.info, "\(Self.logTag) - socket disconnected. Reason: \(reason). Code: \(code)")
            isConnected = false
            
        case .text(let message):
            log(.info, "\(Self.logTag) - received message from socket: \(message)")
            delegate?.onMessage(message: message)
            
        case .binary(let data):
            let message = String(data: data, encoding: .utf8)
            log(.info, "\(Self.logTag) - received binary message from socket: \(message)")
            if let message = message {
                delegate?.onMessage(message: message)
            } else {
                log(.warn, "\(Self.logTag) - received binary message from socket, but could not parse it.")
            }
                        
        case .error(let error):
            isConnected = false
            log(.error, "\(Self.logTag) - socket error: \(error?.localizedDescription)")
            delegate?.onFailed(error: error)
            
        case .cancelled:
            isConnected = false
            log(.warn, "\(Self.logTag) - socket connection cancelled")
            
        case .ping, .pong, .viabilityChanged, .reconnectSuggested:
            break // Unhandled
        }
    }
}
