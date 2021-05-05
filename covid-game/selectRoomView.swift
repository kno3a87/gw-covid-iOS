//
//  selectRoomView.swift
//  covid-game
//
//  Created by ayana.kuno on 2021/05/04.
//

import SwiftUI

struct selectRoomView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background-select-room")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350, alignment: .center)
                VStack {
                    // 画面遷移
                    NavigationLink(destination: createRoomView()) {
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
            print("ルーム画面！")
        }
    }
}

struct selectRoomView_Previews: PreviewProvider {
    static var previews: some View {
        selectRoomView()
    }
}
