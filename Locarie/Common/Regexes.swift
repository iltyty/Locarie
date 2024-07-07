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
  static let letter = ChoiceOf {
    CharacterClass.anyOf("abcdefghijklmnopqrstuvwxyz")
    CharacterClass.anyOf("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  }

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

  static let firstName = Regex {
    Repeat(1 ... 25) {
      letter
    }
  }

  static let lastName = Regex {
    Repeat(1 ... 25) {
      letter
    }
  }

  static let username = Regex {
    Repeat(1 ... 25) {
      ChoiceOf {
        One(.word)
        "."
      }
    }
  }

  static let password = Regex {
    Repeat(8 ... 20) {
      ChoiceOf {
        One(.word)
        CharacterClass.anyOf("!@#$%^&*()-_=+[]{}|;:',.<>?/`~\"\\")
      }
    }
  }

  static let businessName = Regex {
    Repeat(1 ... 25) {
      ChoiceOf {
        One(.word)
        " "
      }
    }
  }
}
