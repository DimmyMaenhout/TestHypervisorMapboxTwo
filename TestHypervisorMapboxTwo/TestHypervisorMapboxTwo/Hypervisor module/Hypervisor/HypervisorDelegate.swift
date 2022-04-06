//
//  HypervisorDelegate.swift
//  Hypervisor
//
//  Created by Maarten Zonneveld on 23/02/2021.
//

import HypervisorCore
import CoreLocation.CLLocation

/// Listener to communicate events from hypervisor, this must be implemented to make hypervisor work with your app.
public protocol HypervisorDelegate: AnyObject {
    
    /// Check if the user is deviated from the route.
    func onUserDeviatedFromRoute(isUserDeviated: Bool)
    
    /// The last known location of the user.
    func getLastKnownLocation() -> CLLocation?
    
    /// When a message is received from the websocket.
    func onEventReceived(event: String)
    
    /// The distance away from the destination. `nil` is returned when the user isn't in range of the set radius.
    func onUserInRangeOfDestination(distance: Double?)
    
    /// The route that is currently active.
    func onRouteStarted(route: HypervisorRoute)
    
    /// The part of the route that is currently active.
    func onRoutePartStarted(part: RoutePart)
    
    /// The part of the route that is currently finished.
    func onRoutePartFinished(part: RoutePart)
    
    /// The part of the route that is currently stopped.
    func onRoutePartStopped(part: RoutePart)
    
    /// The Delay information that is received by the server. This can be serveral types.
    func onDelayReceived(delay: Delay)
    
    /// Public transport stop event. This can be a progress, transfer update or cancellation event.
    func onPublicTransportStopChanged(publicTransportStopInfo: PublicTransportStopInfo)
    
    /// InfeasibleEvent is sent out when a certain route isn't feasible anymore because of certain delays of certain parts/legs or if a part/leg is cancelled. The reason will be sent.
    func onInfeasibleReceived(infeasibilityReason: InfeasibilityReason)
    
    /// The ETA information for the current route. Can be used to display new arrival time.
    func onETAChanged(eta: ETAResponseMessage)
    
    /// The route that is currently stopped.
    func onRouteStopped(route: HypervisorRoute)
    
    /// The route that is currently updated.
    func onRouteUpdated(route: HypervisorRoute)
    
    /// Check if destination is reached
    func onDestinationReached()
    
    /// When an alternative route is found and needs to be shown to the user.
    func onAlternativeRoutesReceived(routes: [HypervisorRoute])
}
