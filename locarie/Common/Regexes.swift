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

  static let username = Regex {
    Repeat(1 ... 25) {
      One(.word)
    }
  }

  static let password = Regex {
    Repeat(8 ... 20) {
      One(.word)
    }
  }

  static let businessName = Regex {
    Repeat(1 ... 25) {
      One(.word)
    }
  }
}
