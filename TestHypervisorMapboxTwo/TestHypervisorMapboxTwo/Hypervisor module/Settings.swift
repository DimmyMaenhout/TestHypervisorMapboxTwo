//
//  Settings.swift
//  TestHypervisorMapbox
//
//  Created by Dimmy Maenhout on 22/03/2022.
//

//import Hypervisor
//import HypervisorConverter

enum Settings {
    @UserDefault("kSocketUrl", defaultValue: HypervisorWebSocketBaseURL.beta.rawValue)
    static var socketUrl: String {
        didSet { HypervisorController.socketEnvironment = HypervisorWebSocketEnvironment(rawValue: socketUrl) ?? .production }
    }
    
    @UserDefault("kRouteConverterURL", defaultValue: RouteConverterApiService.BaseURL.beta.rawValue)
    static var routeConverterBaseURL: String {
        didSet { RouteConverterApiService.baseURL = RouteConverterApiService.BaseURL(rawValue: routeConverterBaseURL) ?? .production }
    }
    
    @UserDefault("kIsLineCenteredWithinCamera", defaultValue: true)
    static var isLineCenteredWithinCamera: Bool
    
    static var kIsLogViewEnabled = "kIsLogViewEnabled"
    @UserDefault(kIsLogViewEnabled, defaultValue: true)
    static var isLogViewEnabled: Bool
}
