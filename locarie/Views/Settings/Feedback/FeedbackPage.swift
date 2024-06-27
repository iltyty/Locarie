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
    VStack {
      NavigationBar("Feedback", divider: true)
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
        feedbackEditor
        shareButton.onTapGesture {
          isEditing = false
        }
      }
      .padding(.horizontal, 16)
      .keyboardDismissable(focus: $isEditing)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .loadingIndicator(loading: $loading)
    .alert(alertText, isPresented: $presentingAlert) {
      Button("OK") {}
    }
    .ignoresSafeArea(.keyboard)
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
    Text("Share your feedback with us.")
      .font(.custom(GlobalConstants.fontName, size: 20))
      .foregroundStyle(Color.locariePrimary)
  }

  var paragraph: some View {
    Text("""
    We would love to hear about your experience with Locarie. Share your feedback about Locarie and report any problems or what we can improve to make your experience even better.

    Please share it and let us know.
    """)
  }

  var feedbackEditor: some View {
    GeometryReader { proxy in
      VStack {
        TextEditorPlusWithLimit(
          viewModel: editVM,
          hint: "Share your feedback...",
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
