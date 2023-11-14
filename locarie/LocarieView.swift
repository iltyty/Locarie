//
//  ContentView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI
import CoreLocation

struct LocarieView: View {
    @EnvironmentObject var viewRouter: BottomTabViewRouter
    
    var body: some View {
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

#Preview {
    LocarieView()
        .environmentObject(BottomTabViewRouter())
        .environmentObject(PostViewModel())
        .environmentObject(MessageViewModel())
}

