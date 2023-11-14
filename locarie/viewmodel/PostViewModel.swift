//
//  PostViewModel.swift
//  locarie
//
//  Created by qiuty on 2023/11/11.
//

import Foundation

// getAllPosts() -> [Post]
class PostViewModel: ObservableObject {
    
    var posts: [Post] = []
    var favoritePosts: [Post] = []
    
    init() {
        posts = getAllPosts()
        favoritePosts = getFavoritePosts()
    }
    
    func getAllPosts() -> [Post] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return [
            Post(
                uid: 2,
                title: "Creme brûlée danishes on today 🌼",
                content: "Our bakers have stunned us once again! Creme brûlée danishes on today 🌼",
                time: dateFormatter.date(from: "2023-11-11 17:09:10")!,
                imageNames: ["post1", "BusinessCover1"]
            ),
            Post(
                uid: 3,
                title: "Wood roasted Velvet crab rice.",
                content: """
                    At the moment we are serving one of our favourite rice dishes which is made with native wild velvet crabs which we source from Wales & Scotland.\
                    The rice is toasted then cooked in a rich aromatic stock made from slowly roasting velvet crabs and vegetables.\
                    To finish we grill a fresh velvet crab then stir the head meat into the rice, \
                    serving the dish with a small herb & citrus salad to be stirred through the rice at the table.
                    """,
                time: dateFormatter.date(from: "2023-11-11 18:20:59")!,
                imageNames: ["post2", "BusinessCover2"]
            ),
        ]
    }
    
    func getFavoritePosts(uid: Int = 1) -> [Post] {
        getAllPosts()
    }
}
