//
//  locarieApp.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI

@main
struct locarieApp: App {
    @StateObject var viewRouter = BottomTabViewRouter()
    
    var body: some Scene {
        WindowGroup {
            LocarieView()
                .environmentObject(viewRouter)
        }
    }
}
