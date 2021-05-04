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
                    Text("ababa")
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

class RoomLoader: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var user = [User]()
    
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
                // JSONからDictionaryへ変換
                let dic = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: String]
                print("room_id: \(dic["room_id"]!)")
                print("user_id: \(dic["user_id"]!)")
            }
        }.resume()
        
    }
}

struct createRoomView_Previews: PreviewProvider {
    static var previews: some View {
        createRoomView()
    }
}
