//
//  HomeViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

protocol HomeFeedPost {
    func viewComments(postId: String)
    func likePost(postId: String, selected: Bool)
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeFeedPost {
    
    func viewComments(postId: String) {
        seguePostId = postId
        performSegue(withIdentifier: commentSegueIdentifier, sender: self)
    }
    
    func likePost(postId: String, selected: Bool) {
        // for local usage only. needs to be changed for db functionality.
        var foundPost: GenericPost? = nil
        for post in explorePosts {
            if post.id == postId {
                foundPost = post
            }
        }
        if foundPost != nil {
            if !selected {
                foundPost?.likes.append(user!.id)
            } else {
                foundPost?.likes.removeAll(where: { (id) -> Bool in
                    id == user!.id
                })
            }
        }
//        tableView.reloadData()
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var explorePosts = [GenericPost]()
    var user: GenericUser?
    var commentSegueIdentifier = "commentSegue"
    var seguePostId: String?

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        explorePosts = UserData.shared.explorePosts
        user = UserData.shared.exploreUsers[0]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        explorePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? HomeFeedTableViewCell else {
                return UITableViewCell()
        }
        cell.postImage.image = explorePosts[indexPath.row].image
        cell.userImage.image = explorePosts[indexPath.row].image
        cell.userImage.round()
        cell.username.text = explorePosts[indexPath.row].userId
        cell.likeCount.text = String(explorePosts[indexPath.row].likes.count)
        if explorePosts[indexPath.row].likes.contains(user!.id) {
            cell.likeButton.isSelected = true
        }
        cell.caption.text = explorePosts[indexPath.row].desc
        cell.postId = explorePosts[indexPath.row].id
        cell.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == commentSegueIdentifier,
            let nextVC = segue.destination as? CommentViewController {
            if let post = explorePosts.first(where: { (GenericPost) -> Bool in
                return GenericPost.id == seguePostId
            }) {
                nextVC.user = user
                nextVC.post = post
            }
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
