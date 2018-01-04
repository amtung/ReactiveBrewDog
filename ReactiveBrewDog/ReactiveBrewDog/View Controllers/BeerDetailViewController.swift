//
//  BeerDetailViewController.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/12/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class BeerDetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ibuGuessTextField: UITextField!
    
    var viewModel: BeerDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.reactive.title <~ viewModel.displayNameMP
        abvLabel.reactive.text <~ viewModel.displayAbvIbuMP
        taglineLabel.reactive.text <~ viewModel.displayTaglineMP
        beerImageView.reactive.image <~ viewModel.beerImageMP
        activityIndicator.reactive.isAnimating <~ viewModel.isLoadingImageMP
        descriptionTextView.reactive.text <~ viewModel.displayDescriptionMP
        
        viewModel.ibuGuessMP <~ ibuGuessTextField.reactive.textValues.map { text in
         
            
                return (text ?? "").isEmpty ? nil : Double(text ?? "")
            
        }
        
        view.reactive.backgroundColor <~ viewModel.correctAnswerMP.map { correct in
            if let correct = correct {
                return correct ? .green : .red
            }
            return .white
        }
    }

    

}
