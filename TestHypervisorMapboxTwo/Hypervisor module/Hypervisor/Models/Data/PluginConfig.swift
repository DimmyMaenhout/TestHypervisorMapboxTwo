//
//  Plugin.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 09/02/2021.
//
//import HypervisorCore

/// Plugin class containing information about the plugins
struct PluginConfig: Encodable {
    /// Configuration of the plugin
    let config: BaseConfig
}

class BaseConfig: Encodable {}

class AlternativesConfig: BaseConfig {
    let type: String = "type.googleapis.com/bemobile.routeguidanceplugin.v1.AlternativesConfig"
    let allowAlternatives: Bool = true
    let alternativeModi: AlternativeRouteModiOption
    let selectedModi: [TransferType]?
    let selectedSharedMobilityProviders: [HypervisorSharedMobilityAgency]?
    let amountAlternatives: Int
    let carDelayPercentage: Int
    
    public init(alternativeModi: AlternativeRouteModiOption = .allModi,
                         selectedModi: [TransferType]? = nil,
                         selectedSharedMobilityProviders: [HypervisorSharedMobilityAgency]? = nil,
                         amountAlternatives: Int = 3,
                         carDelayPercentage: Int = 5  ) {
        self.alternativeModi = alternativeModi
        self.selectedModi = selectedModi
        self.selectedSharedMobilityProviders = selectedSharedMobilityProviders
        self.amountAlternatives = amountAlternatives
        self.carDelayPercentage = carDelayPercentage
    }
    
    private enum CodingKeys: String, CodingKey {
        case
            type = "@type",
            allowAlternatives,
            alternativeModi,
            selectedModi,
            selectedSharedMobilityProviders,
            amountAlternatives,
            carDelayPercentage
            
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(allowAlternatives, forKey: .allowAlternatives)
        try container.encode(alternativeModi, forKey: .alternativeModi)
        try container.encode(selectedModi, forKey: .selectedModi)
        try container.encode(selectedSharedMobilityProviders, forKey: .selectedSharedMobilityProviders)
        try container.encode(amountAlternatives, forKey: .amountAlternatives)
        try container.encode(carDelayPercentage, forKey: .carDelayPercentage)
    }
}
