//
//  MessagePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct MessagePage: View {
    @State var searchText = "Search"
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                SearchBarView(text: searchText)
                    .navigationTitle(Constants.navigationTitle)
                    .navigationBarTitleDisplayMode(.inline)
                
                List(0..<20) { _ in
                    NavigationLink {
                        MessageDetailPage()
                    } label: {
                        MessageRowView()
                    }
                }
                .listStyle(.plain)
                
                BottomTabView()
            }
        }
    }
    
    struct Constants {
        static let navigationTitle = "Message"
    }
}

#Preview {
    MessagePage()
        .environmentObject(BottomTabViewRouter())
}
