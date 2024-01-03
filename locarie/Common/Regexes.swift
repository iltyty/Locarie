//
//  Regexes.swift
//  locarie
//
//  Created by qiuty on 25/12/2023.
//

import Foundation
import RegexBuilder

enum Regexes {
  static let word = OneOrMore(.word)

  static let email = Regex {
    ZeroOrMore {
      word
      "."
    }
    word
    "@"
    word
    OneOrMore {
      "."
      word
    }
  }

  static let password = Regex {
    Repeat(8 ... 20) {
      word
    }
  }
}
