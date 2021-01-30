//
//  StudentLocationListMode.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 26.01.2021.
//

import Foundation

public struct StudentLocationModel : Codable {
    let createdAt : String
    let firstName : String
    let lastName : String
    let latitude : Double
    let longitude : Double
    let mapString : String
    let mediaURL : String
    let objectId : String
    let uniqueKey : String
    let updatedAt : String
}

