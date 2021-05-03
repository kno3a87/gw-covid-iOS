//
//  GameView.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/03.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel = GameViewModel()
    
    @State var gameData = GameData()
    
    // 今日の日付（Date()）にDateComponents(second: 31)を追加
    let time = Calendar.current.date(byAdding: DateComponents(second: 31), to: Date())!
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                HStack(alignment: .center) {
                    Image(viewModel.getYuriko())
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
                            Text(String(gameData.point))
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
                        if viewModel.getYuriko() == "yuriko-back" {
                            gameData.point += 200
                        } else {
                            gameData.flag = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                gameData.flag = false
                            }
                        }
                    }) {
                    Image("alcohol")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                    }
                    // 罰の間はボタンを押せなくする
                    .disabled(gameData.flag)
                    Button(action: {
                        gameData.point += 100
                    }) {
                    Image("non-alcohol")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                    }
                    .disabled(gameData.flag)
                }
                .padding(.bottom, 100)
            }
            if gameData.flag {
                Image("batsu")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300, alignment: .center)
                    .padding(.top, 100)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
