//
//  User.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/04.
//

struct HostUser: Codable {
    var room_id: String
    var user_id: String
}

struct GuestUser: Codable {
    var user_id: String
}
