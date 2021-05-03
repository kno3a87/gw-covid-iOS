//
//  GameView.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/03.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel = GameViewModel()
    
    @State var point: Int = 0
    @State var yuriko: String = "yuriko-back"
    // 今日の日付（Date()）にDateComponents(second: 31)を追加
    let time = Calendar.current.date(byAdding: DateComponents(second: 31), to: Date())!
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(getYuriko())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150, alignment: .center)
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Image("money")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50, alignment: .center)
                        Text(String(point))
                    }
                    HStack {
                        Image("timer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50, alignment: .center)
                        // style: .timerでカウントダウン表示に
                        Text(time, style: .timer)
                        // TODO: timeが0になったら終わりの表示
                    }
                }
                .padding(.trailing, 50)
            }
            .padding(.top, 50)
            Spacer()
            HStack(alignment: .center) {
                Button(action: {
                    point += 200
                }) {
                Image("alcohol")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                }
                Button(action: {
                    point += 100
                }) {
                Image("non-alcohol")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    func getYuriko() -> String {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let turn = Bool.random()
            if turn {
                yuriko = "yuriko-front"
            } else {
                yuriko = "yuriko-back"
            }
        }
        return yuriko
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
