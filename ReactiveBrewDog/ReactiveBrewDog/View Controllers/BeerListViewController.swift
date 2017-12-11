//
//  BeerListViewController.swift
//  ReactiveBrewDog
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class BeerListViewController: UIViewController {
    
    var viewModel: BeerListViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var displayTypeSegmentedControl: UISegmentedControl!
 
    override func viewDidLoad() {
        self.viewModel = BeerListViewModel()
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel.displayTypeMP <~ displayTypeSegmentedControl.reactive.selectedSegmentIndexes.map { BeerListDisplayType(rawValue: $0)! }
                
        viewModel.beerUpdatePipe.output.observeValues {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension BeerListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.displayTypeMP.value.cellIdentifier, for: indexPath) as? BeerCollectionViewCell else { return UICollectionViewCell() }
        let cellViewModel = viewModel.getCellViewModel(for: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
}

extension BeerListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // refactor this shit
        let paddingSpace = viewModel.displayTypeMP.value.sectionInsets.left * (viewModel.displayTypeMP.value.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / viewModel.displayTypeMP.value.itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * viewModel.displayTypeMP.value.heightMultiplier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.displayTypeMP.value.sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.displayTypeMP.value.sectionInsets
    }
}

