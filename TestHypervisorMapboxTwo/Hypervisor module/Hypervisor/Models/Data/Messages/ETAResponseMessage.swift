//
//  ETAResponseMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// ETA message from websocket
public class ETAResponseMessage: BaseResponseMessage {
    /// Real ETA
    public let realEta: String
    
    /// Predicted ETA
    public let predictedEta: String
    
    /// Optimal ETA
    public let optimalEta: String
    
    /// Optimal ETA in milliseconds, tt means travel time?
    public let optimalTtMs: Int
    
    /// Real ETA in milliseconds, tt means travel time?
    public let realTtMs: Int
    
    /// Predicted ETA in milliseconds, tt means travel time?
    public let predictedTtMs: Int
    
    /// Delay in milliseconds
    public let delayMs: Int
    
    private enum CodingKeys: String, CodingKey {
        case
            realEta,
            predictedEta,
            optimalEta,
            optimalTtMs,
            realTtMs,
            predictedTtMs,
            delayMs
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        realEta = try container.decode(String.self, forKey: .realEta)
        predictedEta = try container.decode(String.self, forKey: .predictedEta)
        optimalEta = try container.decode(String.self, forKey: .optimalEta)
        optimalTtMs = try container.decode(Int.self, forKey: .optimalTtMs)
        realTtMs = try container.decode(Int.self, forKey: .realTtMs)
        predictedTtMs = try container.decode(Int.self, forKey: .predictedTtMs)
        delayMs = try container.decode(Int.self, forKey: .delayMs)
        try super.init(from: decoder)
    }
}
