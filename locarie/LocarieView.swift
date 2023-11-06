//
//  ContentView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI

struct LocarieView: View {
    @StateObject var viewRouter = BottomTabViewRouter()
    
    private let homeView = HomeView()
    private let favoriteView = FavoriteView()
    private let chatView = MessageHomeView()
    private let profileView = ProfileView()
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewRouter.currentPage {
            case .home:
                homeView
            case .favorite:
                favoriteView
            case .new:
                HomeView()
            case .message:
                chatView
            case .profile:
                profileView
            }
            ZStack {
                BottomTabView(viewRouter: viewRouter)
            }
            .zIndex(1.0)
        }
    }
}

#Preview {
    LocarieView()
}
