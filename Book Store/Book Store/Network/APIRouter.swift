//
//  APIRouter.swift
//  Book Store
//
//  Created by BBVAMobile on 30/01/2021.
//  Copyright © 2021 Alexandre Carvalho. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: APIConfiguration {
    
    case books(search:String, maxResults:String, startIndex:String)
    case getBook(id:String)
    
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .books:
            return .get
        case .getBook:
            return .get
        }
    }
    // MARK: - Parameters
    var parameters: RequestParams {
        switch self {
        case .books(let search, let maxResults, let startIndex):
            return .url(["q":search,"maxResults":maxResults, "startIndex":startIndex])
        case .getBook(let id):
            return.urlValue(id)
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .books:
            return "/books/v1/volumes"
        case .getBook:
            return "/books/v1/volumes/"
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        switch parameters {
            
        case .body(let params):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            
        case .urlValue(let param):
            let components = URLComponents(string: "\(url.appendingPathComponent(path).absoluteString)\(param)")
            urlRequest.url = components?.url
            
        case .url(let params):
            let queryParams = params.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        }
        return urlRequest
    }
}


