//
//  TileBeerCollectionViewCell.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/10/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class TileBeerCollectionViewCell: BeerCollectionViewCell {
    
    @IBOutlet weak var beerImageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var viewModel: BeerCellViewModel! {
        didSet {
            nameLabel.reactive.text <~ viewModel.displayNameMP
            beerImageView.reactive.image <~ viewModel.beerImageMP
            activityIndicator.reactive.isAnimating <~ viewModel.isLoadingImageMP
        }
    }
}
