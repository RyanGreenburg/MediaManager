//
//  HeroDetailCollectionViewCell.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/11/21.
//

import UIKit

class HeroDetailCollectionViewCell: UICollectionViewCell, CellRegisterable {

    @IBOutlet weak var backsplashImageView: ServiceRequestingImageView!
    @IBOutlet weak var posterImageView: ServiceRequestingImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabels()
    }
    
    override func prepareForReuse() {
        backsplashImageView.image = nil
        posterImageView.image = nil
    }
    
    func configure(with movie: Movie) {
        applyGradientLayer()
        titleLabel.text = movie.title
        genreLabel.text = movie.genres?.map(\.name).joined(separator: " / ")
        releaseDateLabel.text = String(movie.releaseDate.split(separator: "-").first ?? "")
        ratingLabel.text = "\(movie.rating)"
        if let path = movie.posterPath {
            posterImageView.url = TMDBEndpoint.urlForImagePath(path)
        }
        if let backdropPath = movie.backdropPath {
            backsplashImageView.contentMode = .scaleAspectFill
            backsplashImageView.url = TMDBEndpoint.urlForImagePath(backdropPath)
        }
    }
    
    private func configureLabels() {
        titleLabel.textColor = .white
        genreLabel.textColor = .white
        ratingLabel.textColor = .white
        releaseDateLabel.textColor = .white
    }

    private func applyGradientLayer() {
        let topColor: UIColor = .clear
        let bottomColor: UIColor = .black
        
        let view = UIView(frame: backsplashImageView.frame)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = backsplashImageView.bounds
        
        view.layer.addSublayer(gradientLayer)
        backsplashImageView.addSubview(view)
        backsplashImageView.bringSubviewToFront(view)
        layoutIfNeeded()
    }
}
