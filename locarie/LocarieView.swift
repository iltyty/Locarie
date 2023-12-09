//
//  ContentView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI
import CoreLocation

struct LocarieView: View {
    @AppStorage("userId") var userId: Double = 0
    @EnvironmentObject var viewRouter: BottomTabViewRouter
    
    var body: some View {
        if userId == 0 {
            // not logged in yet
            LoginPage()
        } else {
            // logged in already
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
        .environmentObject(BottomTabViewRouter())
        .environmentObject(PostViewModel())
        .environmentObject(MessageViewModel())
}

