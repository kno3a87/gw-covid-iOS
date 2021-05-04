//
//  selectRoomView.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/04.
//

import SwiftUI
import Combine

struct selectRoomView: View {
    @ObservedObject var roomLoader = RoomLoader()
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background-select-room")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350, alignment: .center)
                VStack {
                    // 画面遷移
                    NavigationLink(destination: createRoomView(user: roomLoader.user)) {
                        Image("create-room")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 100, alignment: .center)
                    }
                    // 画面遷移
                    NavigationLink(destination: joinRoomView()) {
                        Image("join-room")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 100, alignment: .center)
                    }
                }
            }
        }
        .onAppear {
            roomLoader.call()
        }
    }
}

class RoomLoader: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    // 初期化必要だから適当にぶっこみ！
    @Published private(set) var user = User(room_id: "test", user_id: "test")
    
    func call() {
        print("Heroku呼び出し！")
        let url = URL(string: "https://gw-covid-server.herokuapp.com/room")!
        var request = URLRequest(url: url)
        // POSTを指定
        request.httpMethod = "POST"
        // POSTするデータをBodyとして設定
//        request.httpBody = "os=iOS&version=11&language=日本語".data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                // 送られてきたdata
                print(String(data: data, encoding: .utf8) ?? "")
                // JSONからUserに
                let decoder = JSONDecoder()
                guard let user = try? decoder.decode(User.self, from: data) else {
                    print("Json decode エラー")
                    return
                }
                print(user.room_id)
                print(user.user_id)
                // @Publishedなプロパティを変更するときはmainスレッドからじゃないと警告でる（無視）
                self.user = user
            }
        }.resume()
        
    }
}

struct selectRoomView_Previews: PreviewProvider {
    static var previews: some View {
        selectRoomView()
    }
}
