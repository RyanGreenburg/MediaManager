//
//  DetailViewController.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/11/21.
//

import UIKit

class DetailViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.dataSource = DetailViewDataSource(collectionView: collectionView)
    }

    func configureViewModel(with movie: Movie) {
        viewModel = DetailViewModel(movie: movie)
        viewModel.performRequests()
    }
}
