//
//  PublicTransportInfo.swift
//  HypervisorCore
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

/// More detailed information related to the public transport used
public struct PublicTransportInfo: Codable, Equatable {
    
    /// Name of the route of this public transport vehicle e.g. the line Ghent-Antwerp.
    /// As this is generally the same for both directions, the headsign field should be used to know the direction for the traveler.
    public let name: String?
    
    /// Provider of the public transport used.
    public let agency: String
    
    /// Id of the public transport route e.g. "44" or "IC".
    public let id: String?
    
    /// Headsign for public transport route from public transport provider, often the final destination, e.g. "Bruges/ Brugge".
    /// This is what the transport vehicle will be displaying.
    public let headsign: String?
    
    /// Trip short name from the public transport provider, e.g. "1815".
    public let tripShortName: String?
    
    /// List of stops on the part.
    /// It contains the stop where the vehicle is boarded, followed by the intermediate stops (where the vehicle actually stops, not just drives by), followed by the stop where the vehicle is alighted.
    public let stops: [Stop]
    
    /// ID of the ticket useable on this leg. The ID can be used to find the relevant ticket on the route level.
    public let proposedTicketId: String?
    
    public init(name: String?, agency: String, id: String?, headsign: String?, tripShortName: String?, stops: [Stop], proposedTicketId: String?) {
        self.name = name
        self.agency = agency
        self.id = id
        self.headsign = headsign
        self.tripShortName = tripShortName
        self.stops = stops
        self.proposedTicketId = proposedTicketId
    }
}
