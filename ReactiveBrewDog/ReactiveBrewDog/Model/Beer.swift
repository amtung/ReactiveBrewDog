//
//  Beer.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import Foundation

struct Beer: Codable {
    let name: String
    let id: Int
    let tagline: String
    let firstBrewed: String
    let beerDescription: String
    let imageURLString: String
    let abv: Double
    let ibu: Double
    
    enum CodingKeys: String, CodingKey {
        case name, id, tagline, abv, ibu
        case firstBrewed = "first_brewed"
        case beerDescription = "description"
        case imageURLString = "image_url"
    }
}
