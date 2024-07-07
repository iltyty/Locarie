//
//  FileReadViewModel.swift
//  locarie
//
//  Created by qiuty on 07/07/2024.
//

import SwiftUI

class FileReadViewModel: ObservableObject {
  @Published var data: String = ""

  func load(file: String) {
    if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
      do {
        let contents = try String(contentsOfFile: filepath)
        DispatchQueue.main.async {
          self.data = contents
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    } else {
      print("File not found")
    }
  }
}
