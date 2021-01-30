//
//  UdacityService.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 25.01.2021.
//

import Foundation

public protocol UdacityClientProtocol {
    func login(username: String, password: String, completion:@escaping (Error?) -> Void)
    func getUserInfo(userID: String, completion:@escaping (Result<User, Error>) -> Void)
    func getStudentLocations(limit: Int?, skip: Int?, order: String?, uniqueKey: String?, completion:@escaping (Result<StudentLocationResponseModel, Error>) -> Void)
    func logout(completion:@escaping (Error?) -> Void)
    func postStudentLocation(mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completion:@escaping (Error?) -> Void)
}

public class UdacityClient: UdacityClientProtocol{
    class func sharedinstance() -> UdacityClient {
        struct Singleton {
            static var sharedinstance = UdacityClient()
        }
        return Singleton.sharedinstance
    }
    
    private init() {}
    
    public func login(username: String, password: String, completion:@escaping (Error?) -> Void) {
        NetworkManager.request(endpoint: UdacityEndpoint.login(username: username, password: password), loginResponseParse: true) { (result: Result<LoginResponseModel, Error>) in
            switch result {
            case.success(let response):
                UserManager.shared.user.userID = response.account.key
                UdacityApiAuth.sessionId = response.session.id
                completion(nil)
            case.failure(let error):
                completion(error)
            }
        }
    }
    
    public func getUserInfo(userID: String, completion:@escaping (Result<User, Error>) -> Void) {
        NetworkManager.request(endpoint: UdacityEndpoint.getUser(userID: userID), loginResponseParse: true) { (result: Result<User, Error>) in
            switch result {
            case.success(let response):
                completion(.success(response))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getStudentLocations(limit: Int? = nil, skip: Int? = nil, order: String? = nil, uniqueKey: String? = nil, completion:@escaping (Result<StudentLocationResponseModel, Error>) -> Void) {
        NetworkManager.request(endpoint: UdacityEndpoint.getStudentLocationList(limit: limit, skip: skip, order: order, uniqueKey: uniqueKey)) { (result: Result<StudentLocationResponseModel, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func logout(completion: @escaping (Error?) -> Void) {
        NetworkManager.request(endpoint: UdacityEndpoint.logout, loginResponseParse: true) { (result: Result<LogoutResponseModel, Error>) in
            switch result {
            case .success( _):
                UserManager.reset()
                UdacityApiAuth.sessionId = ""
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    public func postStudentLocation(mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completion: @escaping (Error?) -> Void) {
        NetworkManager.request(endpoint: UdacityEndpoint.postStudentLocation(user: UserManager.shared.user, mapString: mapString, mediaUrl: mediaUrl, latitude: latitude, longitude: longitude)) { (result: Result<PostStudentLocationResponseModel, Error>) in
            switch result {
            case .success( _):
                completion(nil)
                break
            case .failure(let error):
                completion(error)
                break
            }
        }
    }
    
}
