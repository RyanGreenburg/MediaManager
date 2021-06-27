//
//  MoviesHomeViewController.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/9/21.
//

import UIKit

class MoviesHomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: MoviesHomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MoviesHomeViewModel(collectionView: collectionView)
        collectionView.dataSource = viewModel.dataSource
        collectionView.delegate = self
        title = "Movies"
        configureSearchController()
    }
    
    private func configureSearchController() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.scopeButtonTitles = ["Movies", "TV", "People"]
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension MoviesHomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        switch searchController.searchBar.scopeButtonTitles {
        
        default:
            return
        }
    }
}

extension MoviesHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = viewModel.sections[indexPath.section].items[indexPath.row]
        let vc = DetailViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
        vc.configureViewModel(with: selectedItem.movie)
    }
}
