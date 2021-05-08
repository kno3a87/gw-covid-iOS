//
//  GameView.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/03.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel = GameViewModel()
//    @ObservedObject var roomLoader: RoomLoader
    @ObservedObject var roomLoader = RoomLoader()
    @State var roomId: String
    @State var gameData = GameData()
    @State var timer: Timer?
       
    var body: some View {
        ZStack(alignment: .center) {
            if gameData.start {
                Button(action: {
                    print("ルームIDは", roomId)
                    roomLoader.sendMessage(roomId: roomId)
                    gameData.start = false
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){_ in
                        gameData.time -= 1
                    }
                }) {
                Image("start")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300, alignment: .center)
                }
            }
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
                            Text("0:" + String(format: "%02d", gameData.time))
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
                            gameData.buttonFlag = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                gameData.flag = false
                                gameData.buttonFlag = false
                            }
                        }
                    }) {
                    Image("alcohol")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                    }
                    // 罰の間はボタンを押せなくする
                    .disabled(gameData.buttonFlag)
                    Button(action: {
                        gameData.point += 100
                    }) {
                    Image("non-alcohol")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                    }
                    .disabled(gameData.buttonFlag)
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
            if gameData.time == 0 {
                Image("timeup")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300, alignment: .center)
                    .padding(.top, 100)
                    .onAppear{
                        gameData.buttonFlag = true
                        // カウントダウン止める
                        self.timer?.invalidate()
                    }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(roomId: "")
    }
}
