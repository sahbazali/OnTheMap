//
//  UserModel.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 25.01.2021.
//

import Foundation

class UserManager
{
    static let shared = UserManager()
    
    private init() {}
    
    var user: User = User(lastName: "", firstName: "", userID: "")
    var currentLocationId: String = ""
    
    class func reset()
    {
        UserManager.shared.user.firstName = ""
        UserManager.shared.user.lastName = ""
        UserManager.shared.user.userID = ""
        UserManager.shared.currentLocationId = ""
    }
}

public struct User : Codable
{
    var lastName:String
    var firstName:String
    var userID:String
    
    enum CodingKeys : String, CodingKey
    {
        case lastName = "last_name"
        case firstName = "first_name"
        case userID = "key"
        
    }
}
