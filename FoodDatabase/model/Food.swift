//
//  Food.swift
//  FoodDatabase
//
//  Created by Gábor Horváth on 2022. 12. 31..
//

import Foundation

struct Food: Codable {
    let id: String?
    let name : String
    let quantity : Int
    let barcode : String
    let allergens : [String]
    let ingredients : [String]
    let photo : String?
}
