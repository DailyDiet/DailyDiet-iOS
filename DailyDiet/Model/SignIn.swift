//
//  SignIn.swift
//  DailyDiet
//
//  Created by ali on 5/24/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import Foundation


// MARK: - SignIn
struct SignIn: Codable {
    var accessToken, refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
