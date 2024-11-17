//
//  ProfileOpeningHours.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileOpeningHours: View {
  let user: UserDto

  @State private var isPresented = false
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

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
      Image("Clock")
        .resizable()
        .scaledToFit()
        .frame(size: ProfileConstants.iconSize)
    }
  }

  @ViewBuilder
  var openingHoursText: some View {
    if user.businessHours.isEmpty {
      Text(cacheVM.getUserId() == user.id ? "Edit" : "Opening hours")
        .foregroundStyle(LocarieColor.greyDark)
    } else if user.currentOpeningPeriod == 0 {
      Text("Closed").foregroundStyle(LocarieColor.greyDark)
    } else {
      HStack(spacing: 0) {
        Text("Open ").foregroundStyle(LocarieColor.green)
        Text(user.openUtil)
      }
    }
  }

  var rightButton: some View {
    Image("Chevron.Right")
      .resizable()
      .scaledToFit()
      .frame(size: 16)
      .onTapGesture { isPresented = true }
  }

  @ViewBuilder
  var sheet: some View {
    if #available(iOS 16.4, *) {
      sheetView.presentationCornerRadius(Constants.cornerRadius)
    } else {
      sheetView
    }
  }

  var sheetView: some View {
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
  }

  var sheetTitle: some View {
    ZStack {
      Label("Opening hours", systemImage: "clock")
        .font(.headline)
        .fontWeight(.semibold)
      HStack {
        Image(systemName: "xmark")
          .frame(size: Constants.xmarkSize)
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
