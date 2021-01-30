//
//  Endpoint.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 25.01.2021.
//

import Foundation

enum HTTPHeader {
    case contentType(String)
    case accept(String)
    case authorization(String)
    var header: (field: String, value: String) {
        switch self {
            case .contentType(let value): return (field: "Content-Type", value: value)
            case .accept(let value): return (field: "Accept", value: value)
            case .authorization(let value): return (field: "Authorization", value: value)
        }
    }
}

protocol ApiProtocol {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem]? { get }
    var method: String { get }
    var body: Data? { get }
    var headers: [HTTPHeader]? { get }
}
