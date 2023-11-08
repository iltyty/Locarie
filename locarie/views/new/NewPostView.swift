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
                navigationBar
                
                photosPicker(imageSize: proxy.size.width * Constants.imageSizeProportion)
                
                editor(
                    contentEditorHeight: proxy.size.height * Constants.contentEditorHeightProportion,
                    title: $title,
                    content: $content
                )
                
                shareButton
                
                BottomTabView()
            }
        }
    }
}

extension NewPostView {
    var navigationBar: some View {
        Text(Constants.pageTitle)
            .fontWeight(.bold)
            .font(.title3)
    }
}

extension NewPostView {
    func photosPicker(imageSize: CGFloat) -> some View {
        ScrollView {
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
    }
}

extension NewPostView {
    func editor(
        contentEditorHeight: CGFloat, title: Binding<String>, content: Binding<String>
    ) -> some View {
        VStack {
            TextField("Title", text: title)
                .padding(.horizontal)
            Divider()
                .padding(.horizontal)
            TextField("Paragraph", text: content)
                .padding([.horizontal, .top])
                .frame(height: contentEditorHeight, alignment: .top)
            Divider()
                .padding(.horizontal)
            Spacer()
        }
    }
}

extension NewPostView {
    var shareButton: some View {
        Button {
            print("tapped")
        } label: {
            Text(Constants.btnShareText)
                .font(.title2)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .background(
                    Capsule()
                        .fill(.orange)
                        .frame(width: Constants.btnShareWidth, height: Constants.btnShareHeight)
                )
                .padding(.vertical)
        }
    }
}

fileprivate struct Constants {
    static let pageTitle = "Share"
    static let imageSizeProportion: CGFloat = 1 / 3.5
    static let contentEditorHeightProportion: CGFloat = 1 / 3
    static let btnShareText = "share"
    static let btnShareWidth: CGFloat = 180
    static let btnShareHeight: CGFloat = 50
}

#Preview {
    NewPostView()
        .environmentObject(BottomTabViewRouter())
}
