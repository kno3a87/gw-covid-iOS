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
    
    @ObservedObject var roomLoader = joinRoomLoader()
    
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
                    print("user_idは", roomLoader.guestUser.user_id)
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

class joinRoomLoader: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    // 初期化必要だから適当にぶっこみ！
    @Published private(set) var guestUser = GuestUser(user_id: "test")
    
    func joinCall(roomId: String) {
        print("ルーム参加するよ！")
        let url = URL(string: "https://gw-covid-server.herokuapp.com/room/join")!
        var request = URLRequest(url: url)
        // POSTを指定
        request.httpMethod = "POST"
        // Body設定
        print(roomId)
        let room: String = "{\"room_id\":\"" + roomId + "\"}"
        request.httpBody = room.data(using: .utf8)
        // header設定（これしないとエラーになる）
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                // 送られてきたdata
                print(String(data: data, encoding: .utf8) ?? "")
                // JSONからUserに
                let decoder = JSONDecoder()
                guard let user = try? decoder.decode(GuestUser.self, from: data) else {
                    print("Json decode エラー")
                    return
                }
                print(user.user_id)
                // @Publishedなプロパティを変更するときはmainスレッドからじゃないと警告でる
                DispatchQueue.main.sync {
                    self.guestUser = user
                }
            }
        }.resume()
    }
}

struct joinRoomView_Previews: PreviewProvider {
    static var previews: some View {
        joinRoomView()
    }
}
