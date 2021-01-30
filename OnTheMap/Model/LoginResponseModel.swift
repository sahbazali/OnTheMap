//
//  LoginResponseModel.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 25.01.2021.
//

import Foundation

public struct LoginResponseModel: Codable {
    let account: Account
    let session: Session
}

public struct Account: Codable {
    let registered: Bool
    let key: String

}

public struct Session: Codable {
    let id: String
    let expiration: String
}
