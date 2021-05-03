//
//  gameData.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/03.
//

import Foundation

struct GameData: Codable {
    // 今日の日付（Date()）にDateComponents(second: 31)を追加
    var time = Calendar.current.date(byAdding: DateComponents(second: 31), to: Date())!
    var point: Int = 0
    // flagがtrueだと罰
    var flag: Bool = false
}
