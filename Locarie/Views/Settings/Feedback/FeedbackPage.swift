//
//  FeedbackPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct FeedbackPage: View {
  @State var alertText = ""
  @State var loading = false
  @State var presentingAlert = false

  @FocusState private var isEditing

  @StateObject private var feedbackVM = FeedbackViewModel()
  @StateObject private var editVM = TextEditViewModel(limit: Constants.wordCountLimit)

  var body: some View {
    GeometryReader { proxy in
      VStack {
        NavigationBar("Feedback", divider: true)
        ScrollView {
          VStack(alignment: .leading) {
            title
              .padding(.top, 24)
              .padding(.bottom, 16)
              .onTapGesture {
                isEditing = false
              }
            paragraph
              .padding(.bottom, 24)
              .onTapGesture {
                isEditing = false
              }
            feedbackEditor.frame(height: 350)
            Spacer()
            shareButton.onTapGesture {
              isEditing = false
            }
          }
          .padding(.horizontal, 16)
          .keyboardDismissable(focus: $isEditing)
        }
        .scrollDisabled(true)
      }
      .frame(minHeight: proxy.size.height)
    }
    .loadingIndicator(loading: $loading)
    .alert(alertText, isPresented: $presentingAlert) {
      Button("OK") {}
    }
    .onReceive(feedbackVM.$state) { state in
      handleFeedbackVMStateChange(state)
    }
  }

  private func handleFeedbackVMStateChange(_ state: FeedbackViewModel.State) {
    switch state {
    case .loading:
      loading = true
    case .finished:
      editVM.text = ""
      alertText = "Feedback sent. Thank you for your precious advice!"
      presentingAlert = true
      loading = false
    case let .failed(error):
      alertText = error.description()
      presentingAlert = true
      loading = false
    default: loading = false
    }
  }
}

private extension FeedbackPage {
  @ViewBuilder
  var loadingView: some View {
    if case .loading = feedbackVM.state {
      Color.black
        .opacity(GlobalConstants.loadingBgOpacity)
        .ignoresSafeArea()
        .overlay {
          ProgressView()
            .progressViewStyle(.circular)
        }
    } else {
      EmptyView()
    }
  }
}

private extension FeedbackPage {
  var title: some View {
    Text("Share Your Feedback With Us.")
      .font(.custom(GlobalConstants.fontName, size: 20))
      .foregroundStyle(Color.locariePrimary)
  }

  var paragraph: some View {
    Text("""
    We value your thoughts and experiences on Locarie. \
    Please share your feedback with us—whether it’s a suggestion, \
    an issue you’ve encountered, or something you loved. \
    Your insights help us improve and create a better experience for everyone. \
    Thank you for being an integral part of Locarie.
    """)
  }

  var feedbackEditor: some View {
    GeometryReader { proxy in
      VStack {
        TextEditorPlusWithLimit(
          viewModel: editVM,
          hint: "Share Your Feedback",
          border: true
        )
        .focused($isEditing)
        Color.clear.frame(height: proxy.size.height * 0.3)
      }
    }
  }

  var shareButton: some View {
    Button {
      feedbackVM.send(userId: LocalCacheViewModel.shared.getUserId(), content: editVM.text)
    } label: {
      HStack {
        Spacer()
        BackgroundButtonFormItem(title: "Send")
        Spacer()
      }
    }
    .disabled(editVM.text.isEmpty)
    .opacity(editVM.text.isEmpty ? 0.5 : 1)
  }
}

private enum Constants {
  static let wordCountLimit = 500
}

#Preview {
  FeedbackPage()
}
