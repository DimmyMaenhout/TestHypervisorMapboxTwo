//
//  MapboxConfig.swift
//  HypervisorConverter
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

/// Mapbox configuration object for configuring variables for the mapbox route.
public struct MapboxConfig: Encodable {
    
    /// Whether to return steps and turn-by-turn instructions (true) or not (false, default).
    public let steps: Bool
    
    /// The language of returned turn-by-turn text instructions (see https://docs.mapbox.com/api/navigation/#instructions-languages ).
    public let locale: String
    
    /// The routing profile to use. Possible values are mapbox/driving-traffic, mapbox/driving, mapbox/walking, or mapbox/cycling.
    public let profile: String
    
    /// Displays the requested type of overview geometry. Can be full (the most detailed geometry available), simplified (default, a simplified version of the full geometry), or false (no overview geometry). In practice this means that the polyline returned will contain more/less precision by having more/less points
    public let overview: String?
    
    /// The format of the returned geometry.
    public let geometries: GeometryType
    
    /// An annotations object that contains additional details about each line segment along the route geometry. Each entry in an annotations field corresponds to a coordinate along the route geometry.
    public let annotations: String?
    
    /// Whether to emit instructions at roundabout exits (true) or not (false, default). Without this parameter, roundabout maneuvers are given as a single instruction that includes both entering and exiting the roundabout.
    /// With roundabout_exits=true, this maneuver becomes two instructions, one for entering the roundabout and one for exiting it. Must be used in conjunction with steps=true..
    public let roundabout_exits: String?
    
    /// Whether to return SSML marked-up text for voice guidance along the route (true) or not (false, default). Must be used in conjunction with steps=true.
    public let voice_instructions: Bool
    
    /// Specify which type of units to return in the text for voice instructions. Can be imperial (default) or metric. Must be used in conjunction with be used in conjunction with steps=true and voice_instructions=true.
    public let voice_units: String
    
    /// Whether to return banner objects associated with the route steps (true) or not (false, default). Must be used in conjunction with steps=true.
    public let banner_instructions: Bool
    
    public init(steps: Bool, locale: String, profile: String, overview: String?, geometries: GeometryType, annotations: String?, roundabout_exits: String?, voice_instructions: Bool, voice_units: String, banner_instructions: Bool) {
        self.steps = steps
        self.locale = locale
        self.profile = profile
        self.overview = overview
        self.geometries = geometries
        self.annotations = annotations
        self.roundabout_exits = roundabout_exits
        self.voice_instructions = voice_instructions
        self.voice_units = voice_units
        self.banner_instructions = banner_instructions
    }
}
