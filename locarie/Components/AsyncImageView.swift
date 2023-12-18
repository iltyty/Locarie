//
//  AsyncImageView.swift
//  locarie
//
//  Created by qiuty on 16/11/2023.
//

import Foundation
import SwiftUI

extension URLCache {
  static let imageCache = URLCache(
    memoryCapacity: Constants.memoryCacheCapacity,
    diskCapacity: Constants.diskCacheCapacity
  )
}

extension URLSession {
  static let imageSession: URLSession = {
    let config = URLSessionConfiguration.default
    config.urlCache = .imageCache
    return .init(configuration: config)
  }()
}

struct AsyncImageView<Content: View>: View {
  @State var phase: AsyncImagePhase
  var urlRequest: URLRequest? = nil
  let width: Double
  let height: Double
  var session: URLSession = .imageSession
  let modifier: (Image) -> Content

  init(
    url: String,
    width: Double = .infinity,
    height: Double = .infinity,
    session: URLSession = .imageSession,
    @ViewBuilder modifier: @escaping (Image) -> Content = { image in
      image.resizable()
    }
  ) {
    self.width = width
    self.height = height
    self.modifier = modifier
    guard let url = URL(string: url) else {
      _phase = .init(wrappedValue: .failure(URLError(.badURL)))
      return
    }
    urlRequest = URLRequest(url: url)
    self.session = session
    if let urlRequest,
       let data = session.configuration.urlCache?
       .cachedResponse(for: urlRequest)?.data,
       let uiImage = UIImage(data: data)
    {
      _phase = .init(wrappedValue: .success(.init(uiImage: uiImage)))
    } else {
      _phase = .init(wrappedValue: .empty)
    }
  }

  var body: some View {
    Group {
      switch phase {
      case .empty:
        ProgressView()
          .task { await load() }
      case let .success(image):
        modifier(image)
      default:
        Image(systemName: "questionmark")
      }
    }
    .frame(width: width, height: height)
  }

  func load() async {
    do {
      guard let urlRequest else {
        throw URLError(.badURL)
      }
      let (data, response) = try await session.data(for: urlRequest)
      guard let response = response as? HTTPURLResponse,
            200 ... 299 ~= response.statusCode,
            let uiImage = UIImage(data: data)
      else {
        throw URLError(.resourceUnavailable)
      }
      phase = .success(.init(uiImage: uiImage))
    } catch {
      phase = .failure(error)
    }
  }
}

struct AsyncImageTestView: View {
  @State private var id = UUID()

  var body: some View {
    VStack {
      AsyncImageView(url: "https://i.ibb.co/QMnRsgG/cover-jolene.jpg") { image in
        image
          .resizable()
          .scaledToFit()
          .clipShape(Circle())
          .frame(width: 300, height: 300)
      }
      .frame(width: 300, height: 300)
      .id(id)
      Button("modify") {
        id = UUID()
      }
    }
  }
}

private enum Constants {
  static let memoryCacheCapacity = 50 * 1024 * 1024
  static let diskCacheCapacity = 500 * 1024 * 104
}

#Preview {
  AsyncImageTestView()
}
