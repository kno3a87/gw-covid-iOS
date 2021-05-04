//
//  createRoomView.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/04.
//

import SwiftUI
import Combine

struct createRoomView: View {
    @State private var showCopyAlert = false
    @State private var startFlag = false
    let user: User

    var body: some View {
        ZStack {
            Image("background-room")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 440, alignment: .center)
            VStack {
                ZStack {
                    // バックエンドからはroom_idとuser_id送られてくる
                    Image("room-id")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 200, alignment: .center)
                    Text(verbatim: user.room_id)
                        .frame(width: 200, height: 100, alignment: .bottom)
                }
                Button(action: {
                    self.showCopyAlert = true
                    UIPasteboard.general.string = "ababa"
                }) {
                Image("copy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 80, alignment: .center)
                }
                .alert(isPresented: $showCopyAlert) {
                    Alert(title: Text("コピーしました！"))
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

struct createRoomView_Previews: PreviewProvider {
    static var previews: some View {
        createRoomView(user: User(room_id: "test", user_id: "test"))
    }
}
