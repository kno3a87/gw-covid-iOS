//
//  gameData.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/03.
//

import Foundation

struct GameData: Codable {
    var start: Bool = true
    var time: Int = 10
    var point: Int = 0
    // flagがtrueだと罰
    var flag: Bool = false
}
