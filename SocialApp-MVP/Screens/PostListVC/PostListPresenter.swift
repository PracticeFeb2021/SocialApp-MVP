//
//  PostListPresenter.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

protocol PostListViewP: NSObjectProtocol {
    
    func setPosts(_ posts: [Post])
}

protocol PostListPresenterP: class {

    var postListView: PostListViewP? {get set}

    func loadPosts()
}


class PostListPresenter: PostListPresenterP {
            
    let netService: NetworkingService
    
    weak var postListView: PostListViewP?
    
    init(_ netService: NetworkingService) {
        self.netService = netService
    }
  
    func loadPosts() {
        netService.loadPosts { posts in
            DispatchQueue.main.async { [weak self] in
                self?.postListView?.setPosts(posts ?? [])
            }
        }
    }
}

