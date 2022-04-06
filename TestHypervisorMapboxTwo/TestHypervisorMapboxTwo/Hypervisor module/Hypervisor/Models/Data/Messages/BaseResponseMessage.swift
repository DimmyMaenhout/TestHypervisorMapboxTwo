//
//  BaseResponseMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 15/02/2021.
//

/// Base response message
public class BaseResponseMessage: Decodable {
    /// Type
    public let type: String
    
    private enum CodingKeys: String, CodingKey {
        case
            type = "@type"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
    }
}
