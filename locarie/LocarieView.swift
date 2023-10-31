//
//  ContentView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI

struct LocarieView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "location")
                }
            FavoriteView()
                .tabItem {
                   Image(systemName: "bookmark")
                }
            ChatView()
                .tabItem {
                    Image(systemName: "message")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    LocarieView()
}
