//
//  CustomBackSwipeView.swift
//  locarie
//
//  Created by qiuty on 16/11/2023.
//

import SwiftUI

struct CustomBackSwipeView: View {
    @State private var offset = CGSize.zero
    @GestureState private var dragState = DragState.inactive
    @Environment(\.presentationMode) var presentationMode

    enum DragState {
        case inactive
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }

        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("自定义返回动画页面")
                    .font(.title)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .offset(x: self.offset.width, y: 0)
                    .scaleEffect(1 - abs(self.dragState.translation.width / 1000))
                    .gesture(
                        DragGesture()
                            .updating(self.$dragState, body: { (value, state, transaction) in
                                if value.translation.width <= 0 {
                                    return
                                }
                                state = .dragging(translation: value.translation)
                            })
                            .onChanged { value in
                                if value.translation.width <= 0 {
                                    return
                                }
                                self.offset = value.translation
                            }
                            .onEnded { value in
                                if value.translation.width > 200 {
                                    self.presentationMode.wrappedValue.dismiss()
                                } else {
                                    self.offset = .zero
                                }
                            }
                    )
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    CustomBackSwipeView()
}
