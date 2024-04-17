//
//  ProfileOpeningHours.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileOpeningHours: View {
  let user: UserDto

  @State var isPresented = false

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    HStack {
      openingHours
      Spacer()
      if !user.businessHours.isEmpty {
        rightButton
      }
    }
    .lineLimit(1)
    .sheet(isPresented: $isPresented) {
      sheet.presentationDetents([.fraction(Constants.sheetHeightFraction)])
    }
  }
}

private extension ProfileOpeningHours {
  var openingHours: some View {
    Label {
      openingHoursText
    } icon: {
      Image(systemName: "clock")
        .font(.system(size: ProfileConstants.iconSize))
        .frame(width: ProfileConstants.iconSize, height: ProfileConstants.iconSize)
    }
  }

  @ViewBuilder
  var openingHoursText: some View {
    if user.businessHours.isEmpty {
      Text("Go edit").foregroundStyle(.secondary)
    } else if user.isNowClosed {
      Text("Closed").foregroundStyle(.secondary)
    } else {
      HStack(spacing: 0) {
        Text("Open ").foregroundStyle(LocarieColor.green)
        Text(user.openUtil)
      }
    }
  }

  var rightButton: some View {
    Image(systemName: "chevron.right")
      .onTapGesture {
        isPresented = true
      }
  }

  var sheet: some View {
    VStack(spacing: Constants.vSpacing) {
      sheetTitle
      ForEach(user.businessHours) { hours in
        ProfileOpeningHoursItem(hours)
      }
      .padding(.horizontal)
      Spacer()
    }
    .presentationDetents([.medium])
    .presentationDragIndicator(.visible)
    .presentationCornerRadius(Constants.cornerRadius)
  }

  var sheetTitle: some View {
    ZStack {
      Label("Opening hours", systemImage: "clock")
        .font(.headline)
        .fontWeight(.semibold)
      HStack {
        Image(systemName: "xmark")
          .frame(width: Constants.xmarkSize, height: Constants.xmarkSize)
          .onTapGesture {
            isPresented = false
          }
          .padding(.leading)
        Spacer()
      }
    }
    .padding(.top, Constants.vSpacing)
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 32
  static let cornerRadius: CGFloat = 25
  static let xmarkSize: CGFloat = 18
  static let sheetHeightFraction: CGFloat = 0.95
}
