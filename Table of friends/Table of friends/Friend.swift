//
//  Friend.swift
//  FriendFaces
//
//  Created by Lawrence Tsui on 14/1/21.
//

import Foundation
struct Friend: Codable{
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Connection]
}
