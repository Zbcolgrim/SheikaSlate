//
//  Item.swift
//  slate
//
//  Created by Zachary Buffington on 9/16/21.
//

import Foundation

struct CompendiumResponse: Codable {
    let data: [Item]
    
}
struct Item: Codable {
    let name: String
    let description: String
    let image: URL
}
