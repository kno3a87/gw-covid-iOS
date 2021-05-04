//
//  selectRoomViewModel.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/04.
//

import Foundation
import Combine

class selectRoomViewModel: ObservableObject {
    @Published private(set) var user = [User]()
    
    private var cancellables = Set<AnyCancellable>()
    
    func call() {
        let url = URL(string: "https://gw-covid-server.herokuapp.com/")!
//        var urlRequest = URLRequest(url: url)
        // TODO: http methodにGETを指定
//        urlRequest.httpMethod = "POST"
        // TODO: headerに"Accept: application/vnd.github.v3+json"を指定
//        urlRequest.allHTTPHeaderFields = [
//            "Accept": "application/vnd.github.v3+json"
//        ]
        
        let roomPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: [user].self, decoder: JSONDecoder())

        roomPublisher
            // ちゃんとmainスレッドで受け取るよって指定してあげないとエラー
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.err = error
                    print("Error: \(error)")
                case .finished: print("Finished")
                }
                self?.loading = false
            }, receiveValue: { [weak self] repos in
                self?.repos = repos
            }
            ).store(in: &cancellables)
    }
}
