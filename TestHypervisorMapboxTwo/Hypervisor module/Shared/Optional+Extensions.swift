//
//  Optional+Extensions.swift
//  Hypervisor
//
//  Created by Maarten Zonneveld on 22/02/2021.
//

extension Optional {
    
    func cast<T>() -> T? {
        self as? T
    }
    
    func cast<T>(or defaultValue: T) -> T {
        cast() ?? defaultValue
    }
    
    func isNil() -> Bool {
        self == nil
    }
}
