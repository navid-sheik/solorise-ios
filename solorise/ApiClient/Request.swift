//
//  Rrequest.swift
//  solorise
//
//  Created by Navid Sheikh on 27/05/2024.
//

import Foundation

enum HTTPMethod : String{
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
}

final class Request{
    ///Constants for the requests
    private struct Constants{
        static let baseUrl   = "https://98cc-2a02-6b6f-29c2-0-f0c1-6922-e99-9244.ngrok-free.app"
    }
    ///Desird enpoint
    private let endpoint : Endpoint
    
    ///Private components
    private let pathComponents : [String]
    
    ///Query parameters
    private let queryParameters : [URLQueryItem]

    ///The actual urlString with the paths and parameters
    private var urlString :  String{
        var urlString = Constants.baseUrl
        if (endpoint != .base){
            urlString += "/"
            urlString += endpoint.rawValue
         }
        
        if (!pathComponents.isEmpty){
            pathComponents.forEach({
                urlString += "/\($0)"
            })
        }
        if (!queryParameters.isEmpty){
            urlString += "?"
            let argumentString =  queryParameters.compactMap({
                guard let value =  $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            urlString += argumentString
        }
        print(urlString)
        return urlString
    }
    
    ///Url object with full url string
    private var url: URL?{
        return URL(string: urlString)
    }
    
    ///Method for the request
    private var httpMethod : HTTPMethod =  .GET

    ///Headers for the request
    private var headers : [String : String] = [:]
    
    ///Body
    private var body : Data?
    
    ///Desccription
    /// - Parameters
    ///   - endpoint: pass a initial path (e.g auth)
    ///   - pathComponents: arrray contaings the path - e.g ["login"]
    ///   - queryParameters: pass queryItems (e.g UrlQueryItem("success", true))
    public init(endpoint: Endpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        //Set headers here
        self.headers["Content-Type"] =  "application/json"
        
    }
    
    ///Add header field
    func add(headerField field : String, value : String) -> Request{
        self.headers[field] =  value
        return self
    }
    
    ///Set the body
    func set (body : Data?) -> Request {
        self.body = body
        return self
    }
    //Set the method
    func set(method : HTTPMethod) -> Request{
        self.httpMethod =  method
        return self
    }
    
    ///Build the Url Request
    func build() -> URLRequest?{
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.headers
        request.httpMethod =  self.httpMethod.rawValue
        request.httpBody =  self.body
        return request
    }
    
    //TODO: Implement session logic
}
