//
//  NewPostView.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import SwiftUI
import PhotosUI

struct NewPostView: View {
    @State var title = ""
    @State var content = ""
    @StateObject private var viewModel = PhotoViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(Constants.pageTitle)
                    .fontWeight(.bold)
                    .font(.title3)
                
                ScrollView {
                    let imageSize = proxy.size.width / 3.5
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                        ForEach(viewModel.attachments) { imageAttachment in
                            ImageAttachmentView(
                                imageSize: imageSize, imageAttachment: imageAttachment
                            )
                        }
                        PhotosPicker(
                            selection: $viewModel.selection,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Image(systemName: "camera")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: imageSize / 3)
                                .foregroundStyle(.orange)
                                .frame(width: imageSize, height: imageSize)
                                .background(
                                    RoundedRectangle(cornerRadius: 5).fill(.thickMaterial)
                                )
                        }
                    }
                    .padding()
                }
                
                TextField("Title", text: $title)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                TextField("Paragraph", text: $content)
                    .padding([.horizontal, .top])
                    .frame(height: proxy.size.height / 3, alignment: .top)
                
                Divider()
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    print("tapped")
                } label: {
                    Text("share")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .background(
                            Capsule()
                                .fill(.orange)
                                .frame(width: 180, height: 50)
                        )
                        .padding(.vertical)
                }
                
                BottomTabView()
            }
        }
    }
}

fileprivate struct Constants {
    static let pageTitle = "Share"
    static let imageSize: CGFloat = 64
}

#Preview {
    NewPostView()
        .environmentObject(BottomTabViewRouter())
}
