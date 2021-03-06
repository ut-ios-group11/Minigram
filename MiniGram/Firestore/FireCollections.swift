//
//  FireCollections.swift
//  MiniGram
//
//  Created by Keegan Black on 2/12/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation

enum FireCollection: String {
    case Users
    case Posts
    case Miniatures
    
    // Error
    case iOSErrorLogs
    case Null
}

enum FireSubCollection: String {
    case Placeholder //Change as we implement
}

enum FireStorageCollection: String {
    case Users
    case Posts
    case Miniatures
    case Placeholder //Change as we implement
}
