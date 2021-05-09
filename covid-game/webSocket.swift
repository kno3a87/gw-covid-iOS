//
//  webSocket.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/07.
//

import Foundation
import Combine

class RoomLoader: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
//    private var webSocket: URLSessionWebSocketTask?
    
    // 初期化必要だから適当にぶっこみ！
    @Published private(set) var hostUser = HostUser(room_id: "", user_id: "")
    @Published private(set) var guestUser = GuestUser(user_id: "")
    @Published private(set) var message = Message(event: "", room_id: "", user_id: "", details: "")
    @Published private(set) var details = Details(player_count: 0)
    @Published private(set) var game = Game(startFlag: false)
    @Published private(set) var webSocket:URLSessionWebSocketTask? = nil
    
    
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
                // @Publishedなプロパティを変更するときはmainスレッドからじゃないと警告でる
                DispatchQueue.main.sync {
                    self.hostUser = user
                }
                self.webSocket = self.joinWebSocketCall(roomId: self.hostUser.room_id, user_id: self.hostUser.user_id)
            }
        }
        .resume()
    }
    
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
                }
                self.webSocket = self.joinWebSocketCall(roomId: roomId, user_id: self.guestUser.user_id)
            }
        }.resume()
    }
    
    func joinWebSocketCall(roomId: String, user_id: String) -> URLSessionWebSocketTask {
        print("ウェブソケットに入るよ！")
        let wsUrl = "wss://gw-covid-server.herokuapp.com/ws/room/" + roomId + "?user_id=" + user_id
        let url = URL(string: wsUrl)!

        let session = URLSession.shared
        // ws接続
        self.webSocket = session.webSocketTask(with: url)
        self.webSocket!.resume()
        
        self.readMessage(webSocoket: self.webSocket!, url: url)
        
        return self.webSocket!
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
    
    func sendMessage(roomId: String, webSocket: URLSessionWebSocketTask)  {
        print("GameStart:AvoidYurikoメッセージ送信")
        let eventMsg = "{\"event\": "
        let gameStartMsg = "\"GameStart:AvoidYuriko\""
        let roomIdMsg = "\"room_id\": \""+roomId+"\""
        let hostUserIdMsg = "\"user_id\": \"\""
        let detailsMsg = "\"details\": \"\"}"
        let msg = URLSessionWebSocketTask.Message.string(eventMsg+gameStartMsg+","+roomIdMsg+","+hostUserIdMsg+","+detailsMsg)
        webSocket.send(msg) { error in
//        self.webSocket!.send(msg) { error in
          if let error = error {
            print(error)  // some error handling
          }
        }
    }
}


