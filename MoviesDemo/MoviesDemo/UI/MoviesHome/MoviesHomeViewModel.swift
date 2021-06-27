//
//  MoviesHomeViewModel.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/9/21.
//

import UIKit


class MoviesHomeViewModel {
    struct Section: Hashable {
        let type: TMDBEndpoint
        let items: [WrappedMovie]
        
        var title: String {
            switch type {
            case .popular:
                return "Popular"
            case .upcoming:
                return "Upcoming"
            case .topRated:
                return "Top Rated"
            case .nowPlaying:
                return "Now Playing"
            default:
                return ""
            }
        }
    }
    
    struct WrappedMovie: Hashable {
        let movie: Movie
        let id = UUID()
    }
    
    private var activeGroup = DispatchGroup()
    private let tmdbService = TMDBService()
    
    var sections: [Section] = []
    var dataSource: MoviesHomeDataSource
    
    init(collectionView: UICollectionView) {
        dataSource = MoviesHomeDataSource(collectionView: collectionView)
        fetchSectionsForView()
    }
    
    func fetchSectionsForView() {
        fetch(.popular)
        fetch(.topRated)
        fetch(.nowPlaying)
        fetch(.upcoming)
        
        activeGroup.notify(queue: .main) {
            self.dataSource.setData(self.sections)
        }
    }
    
    private func fetch(_ endpoint: TMDBEndpoint) {
        activeGroup.enter()
        tmdbService.fetch(MovieList.self, from: endpoint) { [weak self] result in
            switch result {
            case .success(let list):
                let movies = list.results.map { WrappedMovie(movie: $0) }
                self?.sections.append(Section(type: endpoint, items: movies))
            case .failure(let error):
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
            }
            self?.activeGroup.leave()
        }
    }
}
