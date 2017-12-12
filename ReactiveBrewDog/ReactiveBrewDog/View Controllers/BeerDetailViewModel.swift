//
//  BeerDetailViewModel.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/12/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class BeerDetailViewModel {
 
    var displayTaglineMP = MutableProperty<String>("")
    var displayAbvIbuMP = MutableProperty<String>("")
    var displayNameMP = MutableProperty<String>("")
    var displayDescriptionMP = MutableProperty<String>("")
    var beerImageMP = MutableProperty<UIImage?>(nil)
    var isLoadingImageMP = MutableProperty<Bool>(true)
    
    var correctAnswerMP = MutableProperty<Bool?>(nil)
    
    var ibuGuessMP = MutableProperty<Double?>(nil)
    
    private var beer: Beer!
    
    private let beerRequestManager = BeerRequestManagerFactory.getInstance(type: BeerRequestManagerFactory.type)
    
    private let gameEngine: BeerGameEngine
    
    init(beer: Beer) {
        self.beer = beer
        self.displayNameMP.value = "\(beer.id): \(beer.name)"
        self.displayTaglineMP.value = beer.tagline
        self.displayAbvIbuMP.value = "abv: \(beer.abv)%"
        self.displayDescriptionMP.value = beer.beerDescription
        self.gameEngine = BeerGameEngine(beer: beer)
        fetchBeerImage()
        
        self.correctAnswerMP <~ ibuGuessMP.map { self.gameEngine.isCorrectIBU(guess: $0) }
    }
    
    
    
    private func fetchBeerImage() {
        beerImageMP.value = nil
        beerRequestManager.fetchBeerImage(urlString: beer.imageURLString).on(failed: { error in
            print(error)
        }, value: { [weak self] image in
            self?.beerImageMP.value = image
            self?.isLoadingImageMP.value = false
        }).start()
    }
}
