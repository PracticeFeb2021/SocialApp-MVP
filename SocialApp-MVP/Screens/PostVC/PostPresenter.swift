//
//  PostPresenter.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit


protocol PostViewP: NSObjectProtocol {
    
    func setPost(_ post: Post)
    func setUser(_ user: User)
    
    func setComments(_ comments: [Comment])
}

protocol PostPresenterP: class {
    
    var postView: PostViewP? {get set}
    
    func loadUser(withID id: Int)
    func loadComments(forPostWithID id: Int)
}


class PostPresenter: PostPresenterP {
    
    let netService: NetworkingService
    
    weak var postView: PostViewP?
    
    init(_ netService: NetworkingService) {
        self.netService = netService
    }
    
    func loadUser(withID id: Int) {
        netService.loadUsers { users in
            if let user = users?.first(where: {
                $0.id == id
            }) {
                DispatchQueue.main.async { [weak self] in
                    self?.postView?.setUser(user)
                }
            }
        }
    }
    
    func loadComments(forPostWithID id: Int) {
        netService.loadComments { comments in
            guard let comments1 = comments else {
                print("INFO: No comments received from network")
                return
            }
            let commentsForPost = comments1.filter {
                $0.postId == id
            }
            print("INFO: found \(commentsForPost.count) comments for this post")
            
            DispatchQueue.main.async { [weak self] in
                self?.postView?.setComments(commentsForPost)
            }
        }
    }
}

