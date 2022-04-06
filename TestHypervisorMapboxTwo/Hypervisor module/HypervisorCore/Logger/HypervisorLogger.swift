//
//  HypervisorLogger.swift
//  HypervisorCore
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

import Foundation

@frozen
public enum LogLevel: Int {
    case
        debug,
        info,
        warn,
        error
}

public protocol HypervisorLogger {
    func log(_ level: LogLevel, _ tag: String, _ message: String)
}

internal var logDelegate: HypervisorLogger?
