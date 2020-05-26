//
//  BMI.swift
//  DailyDiet
//
//  Created by ali on 5/24/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import Foundation


// MARK: - Bmi
struct Bmi: Codable {
    var bmiStatus: String
    var bmiValue: Double

    enum CodingKeys: String, CodingKey {
        case bmiStatus = "bmi_status"
        case bmiValue = "bmi_value"
    }
}
