//
//  BeerListViewModel.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result


class BeerListViewModel: NSObject {
    
    private var beers: [Beer] = [] {
        didSet {
            self.beerUpdatePipe.input.send(value: ())
        }
    }
    
    private let beerRequestManager = BeerRequestManagerFactory.getInstance(type: BeerRequestManagerFactory.type)
    
    private var viewModels: [Beer: BeerCellViewModel] = [:]
        
    var beerUpdatePipe = Signal<Void, NoError>.pipe()
    
    override init() {
        super.init()
        fetchMoreBeer()
    }
    
//    // why dos this have to be lazy?
//    lazy var fetchMoreBeerAction: Action<Void, Void, NoError> = {
//        return Action { _ in
//            return SignalProducer<Void, NoError> { [weak self] observer, _ in
//                self?.fetchMoreBeer()
//                observer.sendCompleted()
//            }
//        }
//    }()
    
    func fetchMoreBeer() {
        beerRequestManager.fetchMoreBeer().on(failed: { error in
            print(error)
        }, value: { [weak self] (beers) in
            self?.beers = beers
        }).start()            
    }
    
    // MARK: - Collection View Stuff
    
    func itemsInSection(_ section: Int) -> Int {
        return beers.count
    }
    
    func getCellViewModel(for indexPath: IndexPath) -> BeerCellViewModel {
        let beer = beers[indexPath.row]
        viewModels[beer] = viewModels[beer] ?? BeerCellViewModel(beer: beer)
        return viewModels[beer]!
    }
    
    func isLastIndex(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == beers.count - 1
    }
}
