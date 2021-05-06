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
                    NavigationLink(destination: GameView()) {
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

class joinRoomLoader: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    // 初期化必要だから適当にぶっこみ！
    @Published private(set) var guestUser = GuestUser(user_id: "")
    @Published private(set) var message = Message(event: "", room_id: "", user_id: "", details: "")
    @Published private(set) var details = Details(player_count: 0)
    @Published private(set) var game = Game(startFlag: false)
    
    func joinCall(roomId: String) {
        print("ルーム参加するよ！")
        let url = URL(string: "https://gw-covid-server.herokuapp.com/room/join")!
        var request = URLRequest(url: url)
        // POSTを指定
        request.httpMethod = "POST"
        // Body設定
        let room: String = "{\"room_id\":\"" + roomId + "\"}"
        request.httpBody = room.data(using: .utf8)
        // header設定（これしないとエラーになる）
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        let session = URLSession.shared
        session.dataTask(with: request) { [self] (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                // 送られてきたdata
//                print(String(data: data, encoding: .utf8) ?? "")
                // JSONからUserに
                let decoder = JSONDecoder()
                guard let user = try? decoder.decode(GuestUser.self, from: data) else {
                    print("Json decode エラー")
                    return
                }
                print("ユーザID：", user.user_id)
                // @Publishedなプロパティを変更するときはmainスレッドからじゃないと警告でる
                DispatchQueue.main.sync {
                    self.guestUser = user
                    self.joinWebSocketCall(roomId: roomId, user_id: self.guestUser.user_id)
                }
            }
        }.resume()
    }
    
    func joinWebSocketCall(roomId: String, user_id: String) {
        print("ウェブソケットに入るよ！")
        let wsUrl = "wss://gw-covid-server.herokuapp.com/ws/room/" + roomId + "?user_id=" + user_id
        let url = URL(string: wsUrl)!
        
        let session = URLSession.shared
        // ws接続
        let webSocoket = session.webSocketTask(with: url)
        webSocoket.resume()
        
        self.readMessage(webSocoket: webSocoket, url: url)
    }
    
    func readMessage(webSocoket: URLSessionWebSocketTask, url: URL)  {
        print("joinメッセージ受け取り")
        webSocoket
            .receive { result in
                switch result {
                  case .success(let message):
                    switch message {
                      case .string(let text):
                        let json = text.data(using: .utf8)!
                        let decoder = JSONDecoder()
                        guard let message = try? decoder.decode(Message.self, from: json) else {
                            print("Json decode エラー")
                            return
                        }
                        DispatchQueue.main.sync {
                            self.message = message
                        }
                        let detailsJson = message.details.data(using: .utf8)!
                        let detailsDecoder = JSONDecoder()
                        guard let details = try? detailsDecoder.decode(Details.self, from: detailsJson) else {
                            print("Json decode エラー")
                            return
                        }
                        DispatchQueue.main.sync {
                            self.details = details
                        }
                        print("参加人数：", details.player_count)
                        if details.player_count == 4 {
                            DispatchQueue.main.sync {
                                self.game.startFlag = true
                            }
                        }
                      case .data(let data):
                        print("Received! binary: \(data)")
                      @unknown default:
                        fatalError()
                    }
                  case .failure(let error):
                    print("Failed! error: \(error)")
                }
                // 自分をラップすることで何回もメッセージ受信できる
                self.readMessage(webSocoket: webSocoket, url: url)
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
