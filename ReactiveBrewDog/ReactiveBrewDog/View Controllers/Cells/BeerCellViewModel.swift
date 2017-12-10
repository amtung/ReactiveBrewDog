//
//  BeerCellViewModel.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import Foundation
import ReactiveSwift

class BeerCellViewModel {
    
    var beer: Beer!
    
    var displayName: String {
        return beer.name
    }
    
    var displayTagline: String {
        return beer.tagline
    }
    
    var displayAbvIbu: String {
        return "abv: \(beer.abv)%)"
    }
    
    init(beer: Beer) {
        self.beer = beer
    }
    
}
