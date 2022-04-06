//
//  AlternativeRouteMessage.swift
//  Hypervisor
//
//  Created by Frans FM on 10/11/2021.
//

import Foundation

/// Is called 'AlternativesEvent' in docs but this is consistent with Android
struct AlternativeRouteMessage: Codable, Equatable {
    let alternatives: [Alternative]
    let type: String
    
    private enum CodingKeys: String, CodingKey {
        case
            type = "@type",
            alternatives
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alternatives = try container.decode([Alternative].self, forKey: .alternatives)
        type = try container.decode(String.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alternatives, forKey: .alternatives)
        try container.encode(type, forKey: .type)
    }
}
