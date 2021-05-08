//
//  joinRoomView.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/04.
//

import SwiftUI
import Combine

struct joinRoomView: View {
    @State private var showJoinAlert = false
    @State private var startFlag = false
    @State private var roomId: String = ""
    
    @ObservedObject var roomLoader = RoomLoader()
    
    var body: some View {
        ZStack {
            Image("background-room")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 440, alignment: .center)
            VStack {
                ZStack {
                    Image("input-room-id")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 200, alignment: .center)
                    TextField("ルームID", text: $roomId)
                        .frame(width: 200, height: 100, alignment: .center)
                }
                Button(action: {
                    UIApplication.shared.closeKeyboard()
                    self.showJoinAlert = true
                    // 入室する
                    roomLoader.joinCall(roomId: roomId)
                }) {
                Image("join")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 80, alignment: .center)
                }
                .alert(isPresented: $showJoinAlert) {
                    Alert(title: Text("入室しました！"))
                }
                if roomLoader.game.startFlag {
                    NavigationLink(destination: GameView(roomLoader: roomLoader)) {
                        Image("gamestart-active")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 80, alignment: .center)
                    }
                } else {
                    // 人数揃うまでボタン押せない
                    Image("gamestart-non-active")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 80, alignment: .center)
                }
            }
        }
    }
}


struct joinRoomView_Previews: PreviewProvider {
    static var previews: some View {
        joinRoomView()
    }
}


extension UIApplication {
    func closeKeyboard() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
