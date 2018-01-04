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
            self.beerUpdateObserver.send(value: ())
        }
    }
    
    private let beerRequestManager = BeerRequestManagerFactory.getInstance(type: BeerRequestManagerFactory.type)
    
    private var viewModels: [Beer: BeerCellViewModel] = [:]
        
//    var beerUpdatePipe = Signal<Void, NoError>.pipe()
    
    private var beerUpdateObserver: Signal<Void, NoError>.Observer
    var beerUpdateSignal: Signal<Void, NoError>
    
    override init() {
        let (beerUpdateSignal, beerUpdateObserver) = Signal<Void, NoError>.pipe()
        self.beerUpdateObserver = beerUpdateObserver
        self.beerUpdateSignal = beerUpdateSignal
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
    
    func getDetailViewModel(for indexPath: IndexPath) -> BeerDetailViewModel {
        let beer = beers[indexPath.row]
        return BeerDetailViewModel(beer: beer)
    }
    
    func isLastIndex(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == beers.count - 1
    }
}
