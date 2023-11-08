//
//  ReviewPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI

struct ReviewPage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(0..<10) { _ in
                    ReviewView()
                        .padding()
                }
            }
            Divider()
            Text("Add reviews")
                .fontWeight(.bold)
                .foregroundStyle(.orange)
                .padding(.bottom)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                navigationBar(dismiss)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ReviewPage {
    func navigationBar(_ dismiss: DismissAction) -> some View {
        HStack {
            Image(systemName: "chevron.backward")
                .imageScale(.large)
                .onTapGesture {
                    dismiss()
                }
        }
    }
}

fileprivate struct Constants {
    static let navigationTitle = "Reviews"
}

#Preview {
    ReviewPage()
}
