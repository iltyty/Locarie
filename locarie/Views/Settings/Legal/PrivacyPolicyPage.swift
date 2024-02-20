//
//  PrivacyPolicyPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct PrivacyPolicyPage: View {
  var body: some View {
    VStack {
      navigationBar
      privacyPolicy
      Spacer()
    }
  }
}

private extension PrivacyPolicyPage {
  var navigationBar: some View {
    NavigationTitle("Privacy policy", divider: true)
      .padding(.bottom)
  }

  var privacyPolicy: some View {
    VStack(alignment: .leading) {
      privacyPolicyTitle
      privacyPolicyContent
    }
    .padding(.horizontal)
  }

  var privacyPolicyTitle: some View {
    Text("Privacy policy")
      .font(.headline)
      .foregroundStyle(Color.locariePrimary)
  }

  var privacyPolicyContent: some View {
    Text("""
    Here at Locarie, we aim to foster a sense of community and belonging, both online and offline.

    Our app serves as a platform for local businesses to showcase their unique offerings and connect with a targeted audience. It's more than just social media; it's a community-driven stage for daily specials, events, and products, helping businesses thrive.

    For users, the app is a gateway to discovering local hidden gems, from artisans to unique service providers, supporting and engaging with businesses that define their community's character.

    Our commitment to local businesses upholds the diverse and vibrant nature of our neighbourhoods, inviting everyone to join and celebrate the essence of our community, to make it our home.

    Sunday, December 10th
    """)
  }
}

#Preview {
  PrivacyPolicyPage()
}
