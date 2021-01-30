//
//  NetworkEngine.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 25.01.2021.
//

import Foundation

let sharedCookieStorage = HTTPCookieStorage.shared

class NetworkManager {
    class func request < T: Codable > (endpoint: ApiProtocol, loginResponseParse: Bool = false, completion: @escaping(Result <T, Error>) -> Void) {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else {
            return
        }

        var urlRequest = URLRequest(url: url)
        
        if let headers = endpoint.headers {
            headers.forEach { urlRequest.addValue($0.header.value, forHTTPHeaderField: $0.header.field) }
        }
        
        if endpoint.method == "DELETE" {
            var xsrfCookie: HTTPCookie? = nil
            for cookie in sharedCookieStorage.cookies! {
              if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                urlRequest.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        urlRequest.httpMethod = endpoint.method
        urlRequest.httpBody = endpoint.body

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data,response,error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard response != nil, let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "please try again!"])
                completion(.failure(error))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                var error = NSError()
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    switch statusCode {
                        case 403: error = NSError(domain: "", code: 403, userInfo: [NSLocalizedDescriptionKey: "wrong username or password"])
                        case 404: error = NSError(domain: "", code: 403, userInfo: [NSLocalizedDescriptionKey: "Not found"])
                        case 405: error = NSError(domain: "", code: 403, userInfo: [NSLocalizedDescriptionKey: "not allowed"])
                        default: error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "unknown error"])
                    }
                } else {
                    error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "unknown error"])
                }
                completion(.failure(error))
                return
            }
            
            var checkedData = data
            if loginResponseParse {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                checkedData = newData
            }
            
            DispatchQueue.main.async {
                if let responseObject = try? JSONDecoder().decode(T.self, from: checkedData) {
                        completion(.success(responseObject))
                    } else {
                        let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                        completion(.failure(error))
                    }
            }
        }
        dataTask.resume()
    }
}
