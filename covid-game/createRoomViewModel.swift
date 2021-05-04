////
////  createRoomViewModel.swift
////  covid-game
////
////  Created by ayana.kuno on 2021/05/04.
////
//
//import Foundation
//import Combine
//
//class createRoomViewModel: ObservableObject {
//    private var cancellables = Set<AnyCancellable>()
//    
//    func call() {
//        let reposPublisher = URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap() { element -> Data in
//                guard let httpResponse = element.response as? HTTPURLResponse,
//                    httpResponse.statusCode == 200 else {
//                        throw URLError(.badServerResponse)
//                    }
//                return element.data
//                }
//            .decode(type: [Repo].self, decoder: JSONDecoder())
//
//        reposPublisher
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
//            }, receiveValue: { [weak self] repos in
//                self?.repos = repos
//            }
//            ).store(in: &cancellables)
//    }
//}
//
