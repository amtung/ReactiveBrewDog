//
//  LargeBeerCollectionViewCell.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/10/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import UIKit
import ReactiveSwift

class LargeBeerCollectionViewCell: BeerCollectionViewCell {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
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
