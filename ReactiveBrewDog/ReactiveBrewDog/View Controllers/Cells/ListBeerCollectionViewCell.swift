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
            disposable += nameLabel.reactive.text <~ viewModel.displayNameMP
            disposable += abvLabel.reactive.text <~ viewModel.displayAbvIbuMP
            disposable += taglineLabel.reactive.text <~ viewModel.displayTaglineMP
            disposable += beerImageView.reactive.image <~ viewModel.beerImageMP
            disposable += activityIndicator.reactive.isAnimating <~ viewModel.isLoadingImageMP
        }
    }
}
