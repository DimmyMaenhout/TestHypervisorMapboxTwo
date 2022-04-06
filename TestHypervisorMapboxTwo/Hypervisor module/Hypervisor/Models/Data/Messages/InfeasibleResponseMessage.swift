//
//  InfeasibleResponseMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Infeasible message from websocket
class InfeasibleResponseMessage: BaseResponseMessage {
    /// Infeasibility reason
    let infeasibilityReason: InfeasibilityReason
    
    private enum CodingKeys: String, CodingKey {
        case
            infeasibilityReason
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        infeasibilityReason = try container.decode(InfeasibilityReason.self, forKey: .infeasibilityReason)
        try super.init(from: decoder)
    }
}
