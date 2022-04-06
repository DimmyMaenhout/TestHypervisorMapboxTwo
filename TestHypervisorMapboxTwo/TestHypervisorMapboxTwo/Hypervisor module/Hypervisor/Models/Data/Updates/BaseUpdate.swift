//
//  BaseUpdat.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Message to update a part of the route
class BaseUpdate: Codable {
    /// The id of a part is the place in the route, starting with 0. If you have 3 parts: The first part has id 0, the second 1 and the last 2
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
}
