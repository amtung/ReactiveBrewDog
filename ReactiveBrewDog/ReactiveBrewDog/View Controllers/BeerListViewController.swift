//
//  BeerListViewController.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import UIKit

class BeerListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: BeerListViewModel!
    
    override func viewDidLoad() {
        self.viewModel = BeerListViewModel()
        super.viewDidLoad()

        
    }

}

extension BeerListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}

