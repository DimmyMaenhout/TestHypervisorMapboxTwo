//
//  GeometryType.swift
//  HypervisorConverter
//
//  Created by Maarten Zonneveld on 16/02/2021.
//

public enum GeometryType: String, Encodable {
    
    /// geojson (as LineString)
    case geojson
    
    /// polyline (a polyline with a precision of five decimal places)
    case polyline
    
    /// polyline6 (a polyline with a precision of six decimal places).
    case polyline6
}
