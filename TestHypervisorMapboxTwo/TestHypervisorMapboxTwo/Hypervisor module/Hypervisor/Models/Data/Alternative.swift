//
//  Alternative.swift
//  Hypervisor
//
//  Created by Frans FM on 10/11/2021.
//

import Foundation
import HypervisorCore

public struct Alternative: Codable, Equatable {
    let route: HypervisorRoute
    let entireRoute: Bool
    let partId: Int?
    /// Not optional in docs, but consistent with Android
    let rawMultiModalRoute: String?
}
