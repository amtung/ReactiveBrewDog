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
    
    var beers: [Beer] = [] {
        didSet {
            dump(beers)
            self.beerUpdatePipe.input.send(value: ())
        }
    }
    
    var beerUpdatePipe = Signal<Void, NoError>.pipe()
    
    override init() {
        super.init()
        fetchMoreBeer()
    }
    
    // why dos this have to be lazy?
//    lazy var fetchMoreBeerAction: Action<Void, Void, NoError> = {
//        return Action { _ in
//            return SignalProducer<Void, NoError> { [weak self] observer, _ in
//                self?.fetchMoreBeer()
//                observer.sendCompleted()
//            }
//        }
//    }()
    
    private func fetchMoreBeer() {
        BeerRequestManager.getMoreBeer().on(failed: { error in
            print(error)
        }, value: { [weak self] (beers) in
            self?.beers += beers
        }).start()
    }
    
    
    // MARK: - Collection View Stuff
    
    func itemsInSection(_ section: Int) -> Int {
        return beers.count
    }
    
    func getCellViewModel(for indexPath: IndexPath) -> BeerCellViewModel {
        let beer = beers[indexPath.row]
        return BeerCellViewModel(beer: beer)
    }
}
