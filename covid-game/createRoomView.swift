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
    
    @ObservedObject var roomLoader = createRoomLoader()

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
                    Text(verbatim: roomLoader.hostUser.room_id)
                        .frame(width: 200, height: 100, alignment: .bottom)
                }
                Button(action: {
                    self.showCopyAlert = true
                    UIPasteboard.general.string = roomLoader.hostUser.room_id
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
        .onAppear {
            roomLoader.createCall()
        }
    }
}

class createRoomLoader: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    // 初期化必要だから適当にぶっこみ！
    @Published private(set) var hostUser = HostUser(room_id: "", user_id: "test")
    @Published private(set) var guestUser = GuestUser(user_id: "test")
    
    func createCall() {
        print("ルーム作るよ！")
        let url = URL(string: "https://gw-covid-server.herokuapp.com/room")!
        var request = URLRequest(url: url)
        // POSTを指定
        request.httpMethod = "POST"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                // 送られてきたdata
                print(String(data: data, encoding: .utf8) ?? "")
                // JSONからUserに
                let decoder = JSONDecoder()
                guard let user = try? decoder.decode(HostUser.self, from: data) else {
                    print("Json decode エラー")
                    return
                }
//                print(user.room_id)
//                print(user.user_id)
                // @Publishedなプロパティを変更するときはmainスレッドからじゃないと警告でる
                DispatchQueue.main.sync {
                    self.hostUser = user
                }
            }
        }
        .resume()
    }
}


struct createRoomView_Previews: PreviewProvider {
    static var previews: some View {
        createRoomView()
    }
}
