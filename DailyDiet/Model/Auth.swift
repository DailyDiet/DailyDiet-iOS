//
//  Auth.swift
//  DailyDiet
//
//  Created by ali on 5/24/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import Foundation


// MARK: - Auth
struct Auth: Codable {
    var accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
