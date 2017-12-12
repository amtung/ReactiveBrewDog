//
//  ListBeerCollectionViewCell.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/12/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ListBeerCollectionViewCell: BeerCollectionViewCell {
    
    @IBOutlet weak var abvIBULabel: UILabel!
    
    @IBOutlet weak var taglineLabel: UILabel!
    
    override var viewModel: BeerCellViewModel! {
        didSet {
            nameLabel.reactive.text <~ viewModel.displayNameMP
            beerImageView.reactive.image <~ viewModel.beerImageMP
            activityIndicator.reactive.isAnimating <~ viewModel.isLoadingImageMP
            abvIBULabel.reactive.text <~ viewModel.displayAbvIbuMP
            taglineLabel.reactive.text <~ viewModel.displayTaglineMP
        }
    }
    
    
}
