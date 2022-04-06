//
//  Collection+Extensions.swift
//  Hypervisor
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

extension FlattenSequence {
    
    func toArray() -> [Element] {
        Array(self)
    }
}

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
