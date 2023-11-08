//
//  ContentView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI

struct LocarieView: View {
    @EnvironmentObject var viewRouter: BottomTabViewRouter
    @EnvironmentObject var messageViewMode: MessageViewModel
    
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
        .environmentObject(MessageViewModel())
}
