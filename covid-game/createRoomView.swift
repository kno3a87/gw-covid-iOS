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
//        var urlRequest = URLRequest(url: url)
        // TODO: http methodにGETを指定
//        urlRequest.httpMethod = "POST"
        // TODO: headerに"Accept: application/vnd.github.v3+json"を指定
//        urlRequest.allHTTPHeaderFields = []
        
//        let roomPublisher = URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap() { element -> Data in
//                guard let httpResponse = element.response as? HTTPURLResponse,
//                    httpResponse.statusCode == 200 else {
//                        throw URLError(.badServerResponse)
//                    }
//                return element.data
//                }
//            .decode(type: [User].self, decoder: JSONDecoder())
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(User.self, from: data) else {
                    print("Json decode エラー")
                    print(data)
//                    print(response)
                    print(String(bytes: data, encoding: .utf8)!)
                    return
                }
                print(decodedData)
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()

//        roomPublisher
//            // ちゃんとmainスレッドで受け取るよって指定してあげないとエラー
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                switch completion {
//                case .failure(let error):
//                    self?.err = error
//                    print("Error: \(error)")
//                case .finished: print("Finished")
//                }
//                self?.loading = false
//            }, receiveValue: { [weak self] user in
//                self?.user = user
//            }
//            ).store(in: &cancellables)
    }
}

struct createRoomView_Previews: PreviewProvider {
    static var previews: some View {
        createRoomView()
    }
}
