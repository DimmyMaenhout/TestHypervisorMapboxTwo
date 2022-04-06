//
//  HypervisorWebSocketEnvironment.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 10/02/2021.
//

/// Base urls
public enum HypervisorWebSocketEnvironment: String, CaseIterable {
    case
        production,
        api,
        beta,
        localhost
    
    var url: String {
        switch self {
        case .production: return "wss://routing.be-mobile.io/guidance/v1/ws"
        case .api: return "wss://route-guidance-worker-api.datahub-kube-staging-a.be-mobile.dev/ws"
        case .beta: return "wss://routing-staging.be-mobile.io/guidance/beta/ws"
        case .localhost: return "ws://10.0.2.2:8000/ws"
        }
    }
    
    var apiKey: String {
        switch self {
        case .production: return "G9Do23EQJvFqgJAVFLU4xzyLZa5LvFWj"
        case .api: return "1iS7e41DTIEv4EvfbLVUQoT9qq6"
        case .beta: return "1iS7e41DTIEv4EvfbLVUQoT9qq6"
        case .localhost: return "1iS7e41DTIEv4EvfbLVUQoT9qq6"
        }
    }
}
