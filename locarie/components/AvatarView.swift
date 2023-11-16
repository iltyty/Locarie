//
//  AvatarView.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI

struct AvatarView: View {
    var name: String
    var size: CGFloat
    var imageUrl: String
    
    init(imageUrl: String, size: CGFloat) {
        self.name = ""
        self.size = size
        self.imageUrl = imageUrl
    }
    
    var body: some View {
        AsyncImageView(url: imageUrl, width: size, height: size) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

#Preview {
    AvatarView(imageUrl: "https://picsum.photos/200", size: 128)
}
