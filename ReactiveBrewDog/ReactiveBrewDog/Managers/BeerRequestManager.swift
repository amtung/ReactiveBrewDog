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

enum BeerRequestManagerType {
    case offline
    case online
}

class BeerRequestManagerFactory {
    
    static var type: BeerRequestManagerType = .offline
    
    static func getInstance(type: BeerRequestManagerType) -> BeerRequestManagerTestable {
        switch type {
        case .offline:
            return OfflineBeerRequestManager()
        case .online:
            return BeerRequestManager()
        }
    }
}


protocol BeerRequestManagerTestable {
    func fetchMoreBeer() -> SignalProducer<[Beer], APIError>
    func fetchBeerImage(urlString: String) -> SignalProducer<UIImage?, APIError>
}




class OfflineBeerRequestManager: BeerRequestManagerTestable {
    
    func fetchMoreBeer() -> SignalProducer<[Beer], APIError> {
        return SignalProducer<[Beer], APIError> { observable, disposable in
            
            if let path = Bundle.main.path(forResource: "beers", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let beers = try JSONDecoder().decode([Beer].self, from: data)
                    observable.send(value: beers)
                    observable.sendCompleted()
                } catch {
                    observable.send(error: APIError.jsonDecode(error: error))
                }
            }
        }
    }
    
    func fetchBeerImage(urlString: String) -> SignalProducer<UIImage?, APIError> {
        return SignalProducer<UIImage?, APIError> { observable, disposable in
            let image = UIImage(named: "TestBeerImage")
            observable.send(value: image)
            observable.sendCompleted()
        }
    }
    
    
    
}


class BeerRequestManager: BeerRequestManagerTestable {
    
    var beerEndpoint: String {
        return "https://api.punkapi.com/v2/beers?page=1&per_page=80"
    }
    
    
    
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
    
    private let downloader = ImageDownloader()

    func fetchBeerImage(urlString: String) -> SignalProducer<UIImage?, APIError> {
        return SignalProducer { observer, disposable in
            guard let url = URL(string: urlString) else { return }
            
            self.downloader.download(URLRequest(url: url)) { response in
                
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























