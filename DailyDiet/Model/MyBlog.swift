//
//  MyBlog.swift
//  DailyDiet
//
//  Created by ali on 6/12/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import Foundation



// MARK: - MyBlogItemListValue
struct MyBlogItemListValue: Codable {
    var authorEmail, authorFullname, category, content: String
    var currentUserMail, slug, summary, title: String
    var id: String?

    enum CodingKeys: String, CodingKey {
        case authorEmail = "author_email"
        case authorFullname = "author_fullname"
        case category, content
        case currentUserMail = "current_user_mail"
        case slug, summary, title
    }
}

typealias MyBlogItemList = [String: MyBlogItemListValue]
