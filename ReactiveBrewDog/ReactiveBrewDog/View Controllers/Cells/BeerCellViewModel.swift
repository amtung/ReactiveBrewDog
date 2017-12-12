//
//  BeerCellViewModel.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import Foundation
import ReactiveSwift
import Alamofire
import AlamofireImage

class BeerCellViewModel {
    
    private var beer: Beer! 
    
    var displayTaglineMP = MutableProperty<String>("")
    var displayAbvIbuMP = MutableProperty<String>("")
    var displayNameMP = MutableProperty<String>("")
    var beerImageMP = MutableProperty<UIImage?>(nil)
    var isLoadingImageMP = MutableProperty<Bool>(true)
    
    private let beerRequestManager = BeerRequestManagerFactory.getInstance(type: BeerRequestManagerFactory.type)
    
    init(beer: Beer) {
        self.beer = beer
        self.displayNameMP.value = "\(beer.id): \(beer.name)"
        self.displayTaglineMP.value = beer.tagline
        self.displayAbvIbuMP.value = "abv: \(beer.abv)%"
        fetchBeerImage()
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
