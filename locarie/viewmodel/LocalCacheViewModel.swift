//
//  LocalCacheViewModel.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import Foundation

class LocalCacheViewModel: ObservableObject {
    @Published private var cache = LocalCache.shared
    
    func isLoggedIn() -> Bool {
        return cache.userId != 0
    }
    
    func setUserInfo(_ info: UserInfo) {
        cache.setUserInfo(info)
    }
}
