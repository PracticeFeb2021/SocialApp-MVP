//
//  PostVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

class PostVC: UIViewController, PostViewP {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var postTitleLabel: UILabel!
    
    @IBOutlet weak var postBodyLabel: UILabel!
    
    @IBOutlet weak var postAuthorLabel: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var commentsTableConstraint: NSLayoutConstraint!

    var presenter: PostPresenterP!
    var post: Post!
    var comments = [Comment]()

    //MARK: - View lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setPost(post)
        
        commentsTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: CommentCell.cellReuseId)
        
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        
        presenter.postView = self
        presenter.loadUser(withID: post.userId)
        presenter.loadComments(forPostWithID: post.id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateScrollViewContentSize()
    }

    //MARK: - PostViewP
    
    func setPost(_ post: Post) {
        postTitleLabel.text = post.title
        postBodyLabel.text = post.body
    }
    
    func setUser(_ user: User) {
        postAuthorLabel.text = user.name
    }
    
    func setComments(_ comments: [Comment]) {
        self.comments = comments
        self.commentsTableView.reloadData()
    }
    
    //MARK: - private
   
    private func updateScrollViewContentSize() {
        
        commentsTableConstraint.constant = commentsTableView.contentSize.height + 20.0
        var heightOfSubViews:CGFloat = 0.0
        contentView.subviews.forEach { subview in
            if let tableView = subview as? UITableView {
                heightOfSubViews += (tableView.contentSize.height + 20.0)
            } else {
                heightOfSubViews += subview.frame.size.height
            }
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: heightOfSubViews)
    }
}

extension PostVC: UITableViewDelegate,UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            commentsTableView.dequeueReusableCell(withIdentifier: CommentCell.cellReuseId, for: indexPath) as! CommentCell
        
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}
