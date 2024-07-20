//
//  Network.swift
//  Locarie
//
//  Created by qiuty on 20/07/2024.
//

import Foundation
import Network

final class Network: ObservableObject {
  @Published private(set) var connected = false

  static let shared = Network()

  let monitor = NWPathMonitor()
  let queue = DispatchQueue(label: "NetworkMonitor")

  private init() {
    checkConnection()
  }

  func checkConnection() {
    monitor.pathUpdateHandler = { path in
      self.connected = (path.status == .satisfied)
    }
    monitor.start(queue: queue)
  }
}
