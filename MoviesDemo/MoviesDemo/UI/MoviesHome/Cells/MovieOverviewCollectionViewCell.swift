//
//  MovieOverviewCollectionViewCell.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/9/21.
//

import UIKit

class MovieOverviewCollectionViewCell: UICollectionViewCell, CellRegisterable {
    
    @IBOutlet weak var posterImageView: ServiceRequestingImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    func configure(with movie: Movie) {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor  = UIColor.gray.cgColor
        ratingImageView.layer.cornerRadius = ratingImageView.frame.height / 2
        ratingLabel.text = "\(movie.rating)"
        titleLabel.text = movie.title
        posterImageView.contentMode = .scaleAspectFill
        guard let path = movie.posterPath else { return }
        posterImageView.url = TMDBEndpoint.urlForImagePath(path)
    }
}
