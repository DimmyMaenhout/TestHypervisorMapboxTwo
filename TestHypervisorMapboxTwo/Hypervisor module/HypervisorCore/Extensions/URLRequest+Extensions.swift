//
//  URLRequest+Extensions.swift
//  HypervisorCore
//
//  Created by Maarten Zonneveld on 18/02/2021.
//

import Foundation

public extension URLRequest {
    
    init(
        url: URL,
        httpMethod: String,
        contentType: String = "application/json",
        httpBody: Data? = nil,
        timeoutInterval: TimeInterval = 15
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue(contentType, forHTTPHeaderField: "content-type")
        request.httpBody = httpBody
        request.timeoutInterval = timeoutInterval
        
        self = request
    }
}
