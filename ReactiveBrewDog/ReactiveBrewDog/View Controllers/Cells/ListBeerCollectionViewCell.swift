//
//  ListBeerCollectionViewCell.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ListBeerCollectionViewCell: BeerCollectionViewCell {
   
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    override var viewModel: BeerCellViewModel! {
        didSet {
            nameLabel.reactive.text <~ viewModel.displayNameMP
            abvLabel.reactive.text <~ viewModel.displayAbvIbuMP
            taglineLabel.reactive.text <~ viewModel.displayTaglineMP
            beerImageView.reactive.image <~ viewModel.beerImageMP 
            activityIndicator.reactive.isAnimating <~ viewModel.isLoadingImageMP
        }
    }
}
