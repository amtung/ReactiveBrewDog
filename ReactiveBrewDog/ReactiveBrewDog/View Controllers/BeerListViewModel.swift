//
//  BeerListViewModel.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import Foundation

class BeerListViewModel {
    
    private var beers: [Beer] = []
    
    init() {
        getMoreBeer()
    }
    
    func getMoreBeer() {
        
    }
    
    
    // MARK: - Collection View Stuff
    
    func itemsInSection(_ section: Int) -> Int {
        return beers.count
    }
}
