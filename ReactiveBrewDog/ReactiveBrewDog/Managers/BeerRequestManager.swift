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
import AlamofireImage


class BeerRequestManager: BeerRequestManagerTestable {
    
    private var beerEndpoint: String {
        return "https://api.punkapi.com/v2/beers?page=1&per_page=80"
    }
    
    private let imageDownloader = ImageDownloader()

    func fetchMoreBeer() -> SignalProducer<[Beer], APIError> {
        return APIManager.fetchData(urlString: beerEndpoint).attemptMap { data in
            print(self.beerEndpoint)
            do {
                let beerList = try JSONDecoder().decode([Beer].self, from: data)
                return Result(value: beerList)
            }
            catch {
                return Result(error: .jsonDecode(error: error))
            }
        }
    }
    
    func fetchBeerImage(urlString: String) -> SignalProducer<UIImage?, APIError> {
        return SignalProducer { observer, disposable in
            guard let url = URL(string: urlString) else { return }
            
            self.imageDownloader.download(URLRequest(url: url)) { response in
                
                switch response.result {
                case .success(let image):
                    observer.send(value: image)
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: APIError.image(error: error))
                    observer.sendCompleted()
                }
            }
        }
    }
}























