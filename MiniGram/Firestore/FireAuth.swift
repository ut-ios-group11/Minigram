//
//  FireAuth.swift
//  MiniGramApp
//
//  Created by Keegan Black on 2/12/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FireAuth {
    private init() {}
    static let shared = FireAuth()
    
    let db = Firestore.firestore()
    
    enum AuthError: Error {
        case AccountAlreadyExists
        case MissingUserError
        case SignInError
        case SignOutError
    }
    
    func isUserSignedIn() -> User? {
        return Auth.auth().currentUser
    }
    
    // MARK: Create User
    func createUser(email: String, password: String, onError: @escaping (Error) -> Void, onComplete: @escaping (User) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                onError(error)
            }
            guard let result = result else {
                onError(AuthError.AccountAlreadyExists)
                return
            }
            onComplete(result.user)
        }
    }
    
    // MARK: Sign In/Out Methods
    func signIn(login: String, pass: String, onError: @escaping (Error) -> Void, onComplete: @escaping (User) -> Void) {
        Auth.auth().signIn(withEmail: login, password: pass) { (result, error) in
            guard error == nil else {
                onError(error!)
                return
            }
            guard let user = result?.user else {
                onError(AuthError.MissingUserError)
                return
            }
            
            onComplete(user)
        }
    }
    
    func signOut(onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        // Additional stuff before sign out like removing FCM tokens
        signOutHelper(onError: onError, onComplete: onComplete)
    }
    
    func updateEmail(newEmail: String, password: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        guard let email = UserData.shared.getUserEmail() else {
            onError(AuthError.MissingUserError)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        if let currentUser = Auth.auth().currentUser {
            currentUser.reauthenticate(with: credential) { (authResult, error) in
                if let error = error {
                    onError(error)
                } else {
                    currentUser.updateEmail(to: newEmail) { (error) in
                        if let error = error {
                            onError(error)
                        } else {
                            onComplete()
                        }
                    }
                }
            }
        } else {
            onError(AuthError.MissingUserError)
        }
    }
    
    func updatePassword(oldPassword: String, newPassword: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        guard let email = UserData.shared.getUserEmail() else {
            onError(AuthError.MissingUserError)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        
        if let currentUser = Auth.auth().currentUser {
            currentUser.reauthenticate(with: credential) { (authResult, error) in
                if let error = error {
                    onError(error)
                } else {
                    currentUser.updatePassword(to: newPassword) { (error) in
                        if let error = error {
                            onError(error)
                        } else {
                            onComplete()
                        }
                    }
                }
            }
        } else {
            onError(AuthError.MissingUserError)
        }
    }
    
    func signOutHelper(onError: ((Error) -> Void)? = nil, onComplete: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()
            onComplete()
        } catch {
            onError?(error)
        }
    }
}
