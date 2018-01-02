//
//  BeerCollectionViewCell.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/10/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class BeerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var disposable = CompositeDisposable()
    
    var viewModel: BeerCellViewModel! {
        didSet {
            disposable += nameLabel.reactive.text <~ viewModel.displayNameMP
            disposable += beerImageView.reactive.image <~ viewModel.beerImageMP
            disposable += activityIndicator.reactive.isAnimating <~ viewModel.isLoadingImageMP
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposable.dispose()
    }
}
