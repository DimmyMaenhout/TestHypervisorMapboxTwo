//
//  EventTypes.swift
//  Hypervisor
//
//  Created by Marcel Hozeman on 10/02/2021.
//

/// Event types
enum EventTypes: String, Decodable {
    case
        rerouteDeviationEvent = "RerouteDeviationEvent",
        etaEvent = "ETAEvent",
        arrivalDelayEvent = "ArrivalDelayEvent",
        departureDelayEvent = "DepartureDelayEvent",
        cancellationEvent = "CancellationEvent",
        transferUpdateEvent = "TransferUpdateEvent",
        publicTransportProgressEvent = "PublicTransportProgressEvent",
        infeasibleEvent = "InfeasibleEvent",
        routeArrivalDelayEvent = "RouteArrivalDelayEvent",
        alternativesEvent = "AlternativesEvent"
}
