//
//  Blog.swift
//  DailyDiet
//
//  Created by ali on 6/12/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import Foundation



// MARK: - BlogValue
struct BlogValue: Codable {
    var authorEmail, authorFullname, category, content: String
    var currentUserMail, slug, summary, title: String

    enum CodingKeys: String, CodingKey {
        case authorEmail = "author_email"
        case authorFullname = "author_fullname"
        case category, content
        case currentUserMail = "current_user_mail"
        case slug, summary, title
    }
}

typealias Blog = [String: BlogValue]



// MARK: - BlogItem
struct BlogItem: Codable {
    var authorEmail, authorFullname, category, content: String
    var currentUserMail: String
    var postID: Int
    var slug, summary, title: String

    enum CodingKeys: String, CodingKey {
        case authorEmail = "author_email"
        case authorFullname = "author_fullname"
        case category, content
        case currentUserMail = "current_user_mail"
        case postID = "post_id"
        case slug, summary, title
    }
}
