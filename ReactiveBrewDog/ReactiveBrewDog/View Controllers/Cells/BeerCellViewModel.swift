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
    
    var beer: Beer!
    
    var displayName: String {
        return beer.name
    }
    
    var displayTagline: String {
        return beer.tagline
    }
    
    var displayAbvIbu: String {
        return "abv: \(beer.abv)%"
    }
    
    var beerImageMP = MutableProperty<UIImage?>(nil)
    var isLoadingImageMP = MutableProperty<Bool>(true)

    init(beer: Beer) {
        self.beer = beer
        fetchBeerImage()
    }
    
    private func fetchBeerImage() {
        BeerRequestManager.fetchBeerImage(urlString: beer.imageURLString).on(failed: { error in
            print(error)
        }, value: { [weak self] image in
            self?.beerImageMP.value = image
            self?.isLoadingImageMP.value = false
        }).start()
    }
    
}
