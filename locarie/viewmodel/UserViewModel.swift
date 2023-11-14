//
//  UserViewModel.swift
//  locarie
//
//  Created by qiuty on 2023/11/11.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    @AppStorage("userId") var uid: Int = 0  // current user's id
    
    static var users: [User] = []
    
    var currentUser: User {
        UserViewModel.getUserById(self.uid)
    }
    
    init(uid: Int) {
        self.uid = uid
    }
    
    static func generateUsers() {
        var openComponents1 = DateComponents()
        var openComponents2 = DateComponents()
        var closeComponents1 = DateComponents()
        var closeComponents2 = DateComponents()
        openComponents1.hour = 9
        openComponents1.minute = 0
        openComponents2.hour = 10
        openComponents2.minute = 0
        closeComponents1.hour = 21
        closeComponents1.minute = 0
        closeComponents2.hour = 3
        closeComponents2.minute = 30
        users = [
            User(id: 1, username: "Tony Stark", avatarName: "avatar2"),
            User(id: 2, username: "Jolene Hornsey", avatarName: "avatar", coverName: "BusinessCover1",
                 introduction: "Farm-to-table dishes & baked goods are showcased at this down-to-earth, bohemian restaurant.", category: "Restaurant",
                 phone: "02039156760", homepageUrl: "https://www.bigjobakery.com",
                 openTime: openComponents1, closeTime: closeComponents1, latitude: 51.55445566, longitude: -0.11060179, locationName: "Jolene Hornsey Rd"),
            User(id: 3, username: "Shreeji", avatarName: "avatar1", coverName: "BusinessCover2",
                 introduction: "Newsagent & Tobacconist, with a coffee & pastry-bar, curated publications and renovated events spaces.", category: "Cafe",
                 phone: "02039156761", homepageUrl: "http://www.shreejinewsagents.com",
                 openTime: openComponents2, closeTime: closeComponents2, latitude: 51.5186134201, longitude: -0.154531110, locationName: "6 Chiltern St"),
        ]
    }
    
    // TODO: fetch the de-facto result from the backend
    static func getUserById(_ id: Int) -> User {
        generateUsers()
        return users[id > 0 && id <= users.count ? id - 1 : 0]
    }
}
