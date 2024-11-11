//
//  Utils.swift
//  Locarie
//
//  Created by qiu on 2024/11/11.
//


func formatLargeNumber(_ number: Int) -> String {
  switch number {
  case 0: ""
  case 1..<1000: "\(number)"
  case 1000..<1000000: "\(number % 1000)k"
  default: "\(number % 1000000)m"
  }
}
