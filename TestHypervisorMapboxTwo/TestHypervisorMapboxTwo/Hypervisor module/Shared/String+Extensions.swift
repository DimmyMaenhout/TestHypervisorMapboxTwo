//
//  String+Extensions.swift
//  Hypervisor
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

/// Note: Internal access
extension String.StringInterpolation {

    /// Prints `Optional` values by only interpolating it if the value is set. `nil` is used as a fallback value to provide a clear output.
    mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T?) {
        appendInterpolation(value ?? "nil" as CustomStringConvertible)
    }
}
