//
//  ChatView.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct MessageHomeView: View {
    @State var searchText = "Search"
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                SearchBar(text: searchText)
                    .navigationTitle(Constants.navigationTitle)
                    .navigationBarTitleDisplayMode(.inline)
                
                List(0..<20) { _ in
                    NavigationLink {
                        MessageDetailView()
                    } label: {
                        MessageRowView()
                    }
                }
                .listStyle(.plain)
            }
        }
    }
    
    struct Constants {
        static let navigationTitle = "Message"
    }
}

#Preview {
    MessageHomeView()
}
