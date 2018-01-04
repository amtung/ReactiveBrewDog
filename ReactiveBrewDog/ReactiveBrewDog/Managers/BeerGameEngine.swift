//
//  BeerGameEngine.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/12/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import Foundation

struct BeerGameEngine {
    
    let beer: Beer
    
    init(beer: Beer) {
        self.beer = beer
    }
    
    func isCorrectIBU(guess: Double?) -> Bool? {
        
        if let correctIBU = beer.ibu, let guess = guess {
            return guess > correctIBU - 5 && guess < correctIBU + 5
        }
        return nil
    }
    
}
