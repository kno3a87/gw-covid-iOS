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

struct Message: Codable {
    var event: String
    var room_id: String
    var user_id: String
    var details: String
}

struct Details: Codable {
    var player_count: Int
}

struct Game: Codable {
    var startFlag: Bool
}
