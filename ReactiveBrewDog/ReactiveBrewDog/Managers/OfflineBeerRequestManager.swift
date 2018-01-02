//
//  OfflineBeerRequestManager.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/12/17.
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
    static var type: BeerRequestManagerType = .online
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
