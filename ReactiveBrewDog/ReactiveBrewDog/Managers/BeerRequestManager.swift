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
import Alamofire

class BeerRequestManager {
    
    static let beerEndpoint = "https://api.punkapi.com/v2/beers?page=1&per_page=80"
    
    static func fetchMoreBeer() -> SignalProducer<[Beer], APIError> {
        return APIManager.fetchData(urlString: beerEndpoint).attemptMap { data in
            do {
                let beerList = try JSONDecoder().decode([Beer].self, from: data)
                return Result(value: beerList)
            }
            catch {
                return Result(error: .jsonDecode(error: error))
            }
        }
    }
    
    static func fetchBeerImage(urlString: String) -> SignalProducer<UIImage?, APIError> {
        return SignalProducer { observer, disposable in
            guard let url = URL(string: urlString) else { return }
            Alamofire.request(url).responseData { (response) in
                if let error = response.error {
                    observer.send(error: .image(error: error))
                }
                if let data = response.data {
                    observer.send(value: UIImage(data: data))
                }
            }
        }
    }
}
