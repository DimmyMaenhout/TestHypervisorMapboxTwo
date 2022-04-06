//
//  CGPoint+Extensions.swift
//  Hypervisor
//
//  Created by Maarten Zonneveld on 25/02/2021.
//

import MapKit

extension CGPoint {
    
    init(_ mapPoint: MKMapPoint) {
        self.init(x: mapPoint.x, y: mapPoint.y)
    }
    
    var mkMapPoint: MKMapPoint {
        MKMapPoint(x: Double(x), y: Double(y))
    }
    
    // Method for calculating the closest point on a line from a point.
    // Used from: https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment/4165840
    func closestPointOnLine(pointA: CGPoint, pointB: CGPoint) -> CGPoint {
        let A = x - pointA.x
        let B = y - pointA.y
        let C = pointB.x - pointA.x
        let D = pointB.y - pointA.y
        
        let dot = A * C + B * D
        let len_sq = C * C + D * D
        let param = dot / len_sq
        
        var xx, yy: CGFloat
        
        if param < 0 || (pointA.x == pointB.x && pointA.y == pointB.y) {
            xx = pointA.x
            yy = pointA.y
        } else if param > 1 {
            xx = pointB.x
            yy = pointB.y
        } else {
            xx = pointA.x + param * C
            yy = pointA.y + param * D
        }
        
        return CGPoint(x: xx, y: yy)
    }
}
