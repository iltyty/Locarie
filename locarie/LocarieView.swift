//
//  ContentView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI
import CoreLocation

struct LocarieView: View {
    @EnvironmentObject var cacheViewModel: LocalCacheViewModel
    @EnvironmentObject var viewRouter: BottomTabViewRouter
    
    var body: some View {
        if !cacheViewModel.isLoggedIn() {
            LoginPage()
        } else {
            switch viewRouter.currentPage {
            case .home:
                HomePage()
            case .favorite:
                FavoritePage()
            case .new:
                NewPostPage()
            case .message:
                MessagePage()
            case .profile:
                UserProfilePage()
            }
        }
    }
}

#Preview {
    LocarieView()
        .environmentObject(LocalCacheViewModel())
        .environmentObject(BottomTabViewRouter())
        .environmentObject(PostViewModel())
        .environmentObject(MessageViewModel())
}

