//
//  post.swift
//  locarie
//
//  Created by qiuty on 2023/11/10.
//

import Foundation

struct Post {
    let id: Int
    let uid: Int  // foreign key of User
    var title: String = ""
    var content: String = ""
    var imageNames: [String] = []  // TODO: switch to url based images
    var time: Date = Date.init()
}
