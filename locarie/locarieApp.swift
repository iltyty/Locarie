//
//  locarieApp.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI

@main
struct locarieApp: App {
    @StateObject var cacheViewModel = LocalCacheViewModel()
    @StateObject var viewRouter = BottomTabViewRouter()
    @StateObject var postViewModel = PostViewModel()
    @StateObject var messageViewModel = MessageViewModel()

    var body: some Scene {
        WindowGroup {
            LocarieView()
                .environmentObject(cacheViewModel)
                .environmentObject(viewRouter)
                .environmentObject(postViewModel)
                .environmentObject(messageViewModel)
        }
    }
}
