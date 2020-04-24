//
//  GenericPost.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import Firebase

class GenericPost: FireInitable {
    
    var id: String
    var userId: String
    var date: Timestamp
    var desc: String
    var likes: [String]
    var image: UIImage?
    var comments = [Comment]()
    var userImage: UIImage?
    
    var user: GenericUser?
    
    required init(doc: DocumentSnapshot) {
        id = doc.documentID
        userId = doc.get("userId") as? String ?? ""
        likes = doc.get("likes") as? [String] ?? [""]
        date = doc.get("date") as? Timestamp ?? Timestamp()
        desc = doc.get("desc") as? String ?? ""
    }
    
    init (id: String, userId:String, likes:[String], desc: String, date: Timestamp, image: UIImage?) {
        self.id = id
        self.userId = userId
        self.likes = likes
        self.date = date
        self.desc = desc
        self.image = image
    }
    
    func update(with post: GenericPost) {
        desc = post.desc
        likes = post.likes
    }
    
    func downloadImageIfMissing(onComplete: (() -> Void)? = nil) {
        if image == nil {
            downloadImage(onComplete: onComplete)
        }
    }
    
    func downloadImageForced(onComplete: (()-> Void)? = nil) {
        downloadImage(onComplete: onComplete)
    }
    
    private func downloadImage(onComplete: (()-> Void)? = nil) {
        Database.shared.downloadPostImage(id: id, onError: { (error) in
            LogManager.logError(error)
        }) { (image) in
            self.image = image
            LogManager.logInfo("Image for post \(self.id) downloaded")
            onComplete?()
        }
    }
    
    func downloadUserImageIfMissing(onComplete: (() -> Void)? = nil) {
        if userImage == nil {
            downloadUserImage(onComplete: onComplete)
        }
    }
    
    func downloadUserImageForced(onComplete: (()-> Void)? = nil) {
        downloadUserImage(onComplete: onComplete)
    }
    
    private func downloadUserImage(onComplete: (()-> Void)? = nil) {
        Database.shared.downloadProfileImage(id: userId, onError: { (error) in
            LogManager.logError(error)
        }) { (image) in
            self.userImage = image
            LogManager.logInfo("Image for user \(self.userId) downloaded")
            onComplete?()
        }
    }
    
    func addComment (comment: Comment) {
        comments.append(comment)
    }
    
    func toDict() -> [String : Any] {
        return [
            "desc": desc,
            "date": date,
            "likes": likes,
            "userId": userId
        ]
    }
    
}
