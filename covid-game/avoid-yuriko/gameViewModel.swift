//
//  gameViewModel.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/03.
//

import Foundation

class GameViewModel: ObservableObject {
    var yuriko: String = "yuriko-back"
    func getYuriko() -> String {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let turn = Bool.random()
            if turn {
                self.yuriko = "yuriko-front"
            } else {
                self.yuriko = "yuriko-back"
            }
        }
        return self.yuriko
    }
}
