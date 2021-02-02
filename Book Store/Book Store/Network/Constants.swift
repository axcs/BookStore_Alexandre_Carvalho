//
//  Constants.swift
//  Book Store
//
//  Created by BBVAMobile on 30/01/2021.
//  Copyright © 2021 Alexandre Carvalho. All rights reserved.
//

import Foundation
import Alamofire

struct Constants {
    struct ProductionServer {
        static let baseURL = "https://www.googleapis.com"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case string = "String"
    
}

enum ContentType: String {
    case json = "Application/json"
    case formEncode = "application/x-www-form-urlencoded"
}

enum RequestParams {
    case body(_:Parameters)
    case url(_:Parameters)
    case urlValue(String)
}
