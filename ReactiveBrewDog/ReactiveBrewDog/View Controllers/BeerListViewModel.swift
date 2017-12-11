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


enum BeerListDisplayType: Int {
    case list, tile, large
    
    var sectionInsets: UIEdgeInsets {
        switch self {
        case .list:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        case .tile:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        case .large:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        }
    }
    
    var itemsPerRow: CGFloat {
        switch self {
        case .large, .list:
            return 1
        case .tile:
            return 4
        }
    }
    
    var heightMultiplier: CGFloat {
        switch self {
        case .list:
            return 0.33
        case .tile, .large:
            return 2
        }
    }
    
    var cellIdentifier: String {
        switch self {
        case .list:
            return "listCell"
        case .tile:
            return "tileCell"
        case .large:
            return "largeCell"
        }
    }
}

class BeerListViewModel: NSObject {
    
    var beers: [Beer] = [] {
        didSet {
            dump(beers)
            self.beerUpdatePipe.input.send(value: ())
        }
    }
    
    private var viewModels: [Beer: BeerCellViewModel] = [:]
    
    var displayTypeMP = MutableProperty<BeerListDisplayType>(.list)
        
    var beerUpdatePipe = Signal<Void, NoError>.pipe()
    
    override init() {
        super.init()
        fetchMoreBeer()
        
        displayTypeMP.producer.on { _ in
            self.beerUpdatePipe.input.send(value: ())
        }.start()
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
        BeerRequestManager.fetchMoreBeer().on(failed: { error in
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
        viewModels[beer] = viewModels[beer] ?? BeerCellViewModel(beer: beer)
        return viewModels[beer]!
    }
}
