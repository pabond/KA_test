//
//  APIRoute.swift
//  KA_test
//
//  Created by Pavel Bondar on 12.05.26.
//

import Foundation

enum APIRoute {
    case usersList(page: Int, results: Int, seed: String?, version: String?)
}

extension APIRoute {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case head = "HEAD"
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var path: String {
        switch self {
        case .usersList:
            return ""
        }
    }
    
    var method: Method {
        switch self {
        case .usersList:
            return .get
        }
    }
    
    var parameters: Any {
        switch self {
        case .usersList(let page, let results, let seed, let version):
            var parameters = ["page" : "\(page)"] as [String : Any]
            parameters["results"] = "\(results)"
            
            if let seed {
                parameters["seed"] = "\(seed)"
            }
            
            if let version {
                parameters["version"] = "\(version)"
            }
            
            return parameters
        }
    }
    
    func makeRequest(baseURLString: String) -> URLRequest? {
        guard
            let baseURL = URL(string: baseURLString),
            var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        
        urlComponents.path = self.path
        
        if let parameters = parameters as? [String : Any] {
            var queryItems: [URLQueryItem] = []
            
            for parameter in parameters {
                if let array = parameter.value as? [String] {
                    let components = array.map{URLQueryItem(name: parameter.key, value: $0)}
                    queryItems += components
                } else if let value = parameter.value as? String {
                    let component = URLQueryItem(name: parameter.key, value: value)
                    queryItems.append(component)
                }
            }
            
            urlComponents.queryItems = queryItems
        }
        
        
        guard let requestURL = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: requestURL)
        request.allHTTPHeaderFields = self.headers
        request.httpMethod = method.rawValue
        
        return request
    }
}
