//
//  BeerRequestManager.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class BeerRequestManager {
    
    let beerEndpoint = "https://api.punkapi.com/v2/beers?page=1&per_page=80"
    
    func getBeers() -> SignalProducer<[Beer], APIError> {
        return APIManager.getData(urlString: beerEndpoint).attemptMap { data in
            do {
                let beerList = try JSONDecoder().decode([Beer].self, from: data)
                return Result(value: beerList)
            }
            catch {
                return Result(error: .jsonDecode(error: error))
            }
        }
    }

}
