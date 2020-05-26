//
//  UserInfo.swift
//  DailyDiet
//
//  Created by ali on 5/24/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import Foundation


// MARK: - UserInfo
struct UserInfo: Codable {
    var confirmed, email, fullName: String

    enum CodingKeys: String, CodingKey {
        case confirmed, email
        case fullName = "full_name"
    }
}
