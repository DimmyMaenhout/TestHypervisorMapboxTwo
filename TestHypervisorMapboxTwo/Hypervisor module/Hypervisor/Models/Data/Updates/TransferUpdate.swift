//
//  TransferUpdate.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

/// Update class for updating the transfer information
class TransferUpdate: BaseUpdate {
    /// There will be multiple radius zones. We will start with three zones: 750m (outer zone), 500m (middle zone) and 250m (inner zone). Inner zone will always be id 0, the middle has id 1 and the outer id 2
    let radiuszone: Int
    
    init(id: Int, radiuszone: Int) {
        self.radiuszone = radiuszone
        super.init(id: id)
    }
    
    private enum CodingKeys: String, CodingKey {
        case radiuszone
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        radiuszone = try container.decode(Int.self, forKey: .radiuszone)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(radiuszone, forKey: .radiuszone)
        try super.encode(to: encoder)
    }
}
