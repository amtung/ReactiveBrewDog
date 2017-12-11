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
        case .tile:
            return 3
         case .large:
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

class BeerListViewController: UIViewController {
    
    var viewModel: BeerListViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var displayTypeSegmentedControl: UISegmentedControl!
    
    var displayType: BeerListDisplayType = .list
 
    override func viewDidLoad() {
        self.viewModel = BeerListViewModel()
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        displayTypeSegmentedControl.reactive.selectedSegmentIndexes.observe(on: UIScheduler()).observeValues { [weak self] index in
            if let displayType = BeerListDisplayType(rawValue: index) {
                self?.displayType = displayType
            }
            self?.collectionView.reloadData()
        }
        
        viewModel.beerUpdatePipe.output.observe(on: UIScheduler()).observeValues { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}

extension BeerListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: displayType.cellIdentifier, for: indexPath) as? BeerCollectionViewCell else { return UICollectionViewCell() }
        let cellViewModel = viewModel.getCellViewModel(for: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if viewModel.isLastIndex(indexPath) {
//            viewModel.fetchMoreBeer()
//        }
//    }
    
}

extension BeerListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // refactor this shit
        let paddingSpace = displayType.sectionInsets.left * (displayType.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / displayType.itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * displayType.heightMultiplier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return displayType.sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return displayType.sectionInsets
    }
}

