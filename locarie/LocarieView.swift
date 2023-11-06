//
//  ContentView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI

struct LocarieView: View {
    @EnvironmentObject var viewRouter: BottomTabViewRouter
    
    var body: some View {
        switch viewRouter.currentPage {
        case .home:
            HomeView()
        case .favorite:
            FavoriteView()
        case .new:
            HomeView()
        case .message:
            MessageHomeView()
        case .profile:
            ProfileView()
        }
    }
}

#Preview {
    LocarieView()
        .environmentObject(BottomTabViewRouter())
}
