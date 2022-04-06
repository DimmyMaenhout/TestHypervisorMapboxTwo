//
//  RouteInfoMessage.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//

import HypervisorCore

/// Response message
struct RouteInfoMessage: Encodable {
    /// The route that is active or needs to be activated
    let route: HypervisorRoute
    /// The plugins that needs to be activated
    let plugins: [PluginConfig]
}
