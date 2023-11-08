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
    var image: Image
    
    init(name: String, size: CGFloat) {
        self.name = name
        self.size = size
        self.image = Image(name)
    }
    
    init(image: Image, size: CGFloat) {
        self.name = ""
        self.size = size
        self.image = image
    }
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

#Preview {
    AvatarView(name: "avatar", size: 128)
}
