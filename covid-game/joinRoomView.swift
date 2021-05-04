//
//  joinRoomView.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/04.
//

import SwiftUI

struct joinRoomView: View {
    @State private var showJoinAlert = false
    @State private var startFlag = false
    @State private var roomId: String = ""
    
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
                    self.showJoinAlert = true
                    // 入室する
                }) {
                Image("join")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 80, alignment: .center)
                }
                .alert(isPresented: $showJoinAlert) {
                    Alert(title: Text("入室しました！"))
                }
                if startFlag {
                    Button(action: {
                        // avoid-yurikoのゲーム画面に遷移
                    }) {
                    Image("gamestart-active")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 80, alignment: .center)
                    }} else {
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
