//
//  APIManager.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import Foundation
import ReactiveSwift

enum APIError: Error {
    case dataTask(error: Error)
    case jsonDecode(error: Error)
    case image(error: Error)
    case unknown
}

class APIManager {
    
   static func fetchData(urlString: String) -> SignalProducer<Data, APIError> {
        return SignalProducer { observer, disposable in
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    observer.send(error: .dataTask(error: error))
                }
                if let data = data {
                    observer.send(value: data)
                }
                observer.sendCompleted()
            })
            task.resume()
        }
        
    }
    
}
