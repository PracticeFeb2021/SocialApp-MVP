//
//  PostListVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

class PostListVC: UIViewController, PostListViewP {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: PostListPresenterP!
    
    var netService: NetworkingService!
    
    var posts = [Post]()
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "Posts"
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: PostCell.cellReuseId)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter.postListView = self
        presenter.loadPosts()
    }
    
    //MARK: - PostListViewP
    
    func setPosts(_ posts: [Post]) {
        self.posts = posts
        tableView.reloadData()
    }
}

//MARK: - TableView

extension PostListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            self.tableView.dequeueReusableCell(withIdentifier: PostCell.cellReuseId, for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        vc.presenter = PostPresenter(netService)
        vc.post = posts[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
