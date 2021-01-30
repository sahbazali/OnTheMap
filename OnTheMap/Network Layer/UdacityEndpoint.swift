//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 25.01.2021.
//

import Foundation

struct UdacityApiAuth {
    static var key = ""
    static var sessionId = ""
}

enum UdacityEndpoint: ApiProtocol {
    
    case login(username: String, password: String)
    case getUser(userID: String)
    case getStudentLocationList(limit: Int?, skip: Int?, order: String?, uniqueKey: String?)
    case logout
    case postStudentLocation(user: User, mapString: String, mediaUrl: String, latitude: Double, longitude: Double)
    
    var apiKey: String {
        switch self {
            default: return ""
        }
    }
    
    var scheme: String {
        switch self {
            default: return "https"
        }
    }
    
    var baseURL: String {
        switch self {
            default: return "onthemap-api.udacity.com"
        }
    }
    
    var path: String {
        switch self {
        case.login, .logout:
            return "/v1/session"
        case .getUser(let userID):
            return "/v1/users/\(userID)"
        case .getStudentLocationList, .postStudentLocation:
            return "/v1/StudentLocation"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case.login:
            return nil
        case .getUser:
            return nil
        case .getStudentLocationList(let limit, let skip, let order, let uniqueKey):
            if limit == nil && skip == nil && order == nil && uniqueKey == nil {
                return nil
            }
            var queryItems : [URLQueryItem] = []
            if let limit = limit {
                queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
            }
            if let skip = skip {
                queryItems.append(URLQueryItem(name: "skip", value: "\(skip)"))
            }
            if let order = order {
                queryItems.append(URLQueryItem(name: "order", value: order))
            }
            if let uniqueKey = uniqueKey {
                queryItems.append(URLQueryItem(name: "uniqueKey", value: uniqueKey))
            }
            return queryItems
        case .logout:
            return nil
        case .postStudentLocation:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .login(let username, let password):
            let dict: [String: Any] = ["udacity": ["username": username, "password": password]]
            let jsonData = try? JSONSerialization.data(withJSONObject: dict)
            return jsonData!
        case .getUser:
            return nil
        case .getStudentLocationList:
            return nil
        case .logout:
            return nil
        case .postStudentLocation(let user, let mapString, let mediaUrl, let latitude, let longitude):
            let dict: [String: Any] = ["uniqueKey": user.userID,
                                       "firstName": user.firstName,
                                       "lastName": user.lastName,
                                       "mapString": mapString,
                                       "mediaURL": mediaUrl,
                                       "latitude": latitude,
                                       "longitude": longitude]
            let jsonData = try? JSONSerialization.data(withJSONObject: dict)
            return jsonData!
        }
    }
    
    var headers: [HTTPHeader]? {
        switch self {
        case .login:
            return [HTTPHeader.accept("application/json"), HTTPHeader.contentType("application/json")]
        case .getUser:
            return nil
        case .getStudentLocationList:
            return nil
        case .logout:
            return nil
        case .postStudentLocation:
            return [HTTPHeader.contentType("application/json")]
        }
    }
    
    var method: String {
        switch self {
        case .login:
            return "POST"
        case .getUser:
            return "GET"
        case .getStudentLocationList:
            return "GET"
        case .logout:
            return "DELETE"
        case .postStudentLocation:
            return "POST"
        }
    }
}
