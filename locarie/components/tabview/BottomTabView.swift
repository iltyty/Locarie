//
//  TabView.swift
//  locarie
//
//  Created by qiuty on 2023/11/5.
//

import SwiftUI

fileprivate struct Constants {
    static let height: CGFloat = 60
    static let iconSize: CGFloat = 25
    static let horizontalPadding: CGFloat = 40
}

struct BottomTabView: View {
    @StateObject var viewRouter: BottomTabViewRouter
    
    var body: some View {
        HStack {
            BottomTabViewItem(page: .home, iconName: "location", viewRouter: viewRouter)
                .imageScale(.large)
            Spacer()
            BottomTabViewItem(page: .favorite, iconName: "bookmark", viewRouter: viewRouter)
                .imageScale(.large)
            Spacer()
            BottomTabViewItem(page: .message, iconName: "message", viewRouter: viewRouter)   .imageScale(.large)
            Spacer()
            BottomTabViewItem(page: .profile, iconName: "person", viewRouter: viewRouter)
                .imageScale(.large)
        }
        .frame(height: Constants.height)
        .padding(.horizontal, Constants.horizontalPadding)
        .background(.regularMaterial)
    }
}

#Preview {
    ZStack {
        Color.blue
        BottomTabView(viewRouter: BottomTabViewRouter())
    }
}
