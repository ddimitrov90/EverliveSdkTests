//
//  Book.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EverliveSDK


public class Book: DataItem {
    // private var title: String = ""
    public var Likes: Int = 0 {
        didSet {
            super.propertyChanged.raise("Likes")
        }
    }
    public var PublishedAt: NSDate? {
        didSet {
            super.propertyChanged.raise("PublishedAt")
        }
    }
    
    public var Title: String? {
        didSet {
            super.propertyChanged.raise("Title")
        }
    }
    
    override public func getTypeName() -> String {
        return "Books"
    }
    
    /*  public var Title:String {
     get {
     return self.title
     }
     set {
     self.title = newValue
     }
     }
     
     public var Likes: Int {
     get {
     return self.likes
     }
     set {
     self.likes = newValue
     }
     }
     
     public var PublishedAt: NSDate? {
     get {
     return self.publishedAt
     }
     set {
     self.publishedAt = newValue
     }
     }
     */
}