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
    @Published private(set) var user = [User]()
    @Published private(set) var err: Error? = nil
    @Published private(set) var loading: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
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
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
        
        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                let decoder = JSONDecoder()
//                guard let decodedData = try? decoder.decode(User.self, from: data) else {
//                    print("Json decode エラー")
//                    print(data)
//                    print(String(bytes: data, encoding: .utf8)!)
//                    return
//                }
//                print(decodedData)
//            } else {
//                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//            }
//        }.resume()
    }
}

struct createRoomView_Previews: PreviewProvider {
    static var previews: some View {
        createRoomView()
    }
}
