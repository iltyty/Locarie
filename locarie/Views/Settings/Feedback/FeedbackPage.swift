//
//  FeedbackPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct FeedbackPage: View {
  @StateObject var feedbackEditViewModel =
    TextEditViewModel(limit: Constants.wordCountLimit)

  var body: some View {
    VStack {
      navigationBar
      content
    }
  }
}

private extension FeedbackPage {
  var navigationBar: some View {
    NavigationTitle("Feedback", divider: true)
  }

  var content: some View {
    VStack(alignment: .leading) {
      title
      paragraph
      feedbackEditor
      shareButton
    }
  }

  var title: some View {
    Text("Share your feedback with us.")
      .font(.headline)
      .foregroundStyle(Color.locariePrimary)
      .padding()
  }

  var paragraph: some View {
    Text("""
    We would love to hear about your experience with Locarie. Share your feedback about Locarie and report any problems or what we can improve to make your experience even better.

    Please share it and let us know.
    """)
    .font(.callout)
    .padding(.horizontal)
  }

  var feedbackEditor: some View {
    GeometryReader { proxy in
      VStack {
        TextEditorPlus(
          viewModel: feedbackEditViewModel,
          hint: "Share your feedback...",
          border: true
        )
        Color.clear
          .frame(height: proxy.size.height * 0.3)
      }
      .padding(.horizontal)
    }
  }

  var shareButton: some View {
    Button {
      print("send")
    } label: {
      HStack {
        Spacer()
        BackgroundButtonFormItem(title: "Send")
        Spacer()
      }
      .padding(.horizontal)
    }
  }
}

private enum Constants {
  static let wordCountLimit = 500
}

#Preview {
  FeedbackPage()
}
