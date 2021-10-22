//
//  MoviesHomeViewModel.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/9/21.
//

import UIKit

@MainActor
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
    
    private let tmdbService: TMDBServicing
    
    var sections: [Section] = []
    var dataSource: MoviesHomeDataSource
    
    init(collectionView: UICollectionView, service: TMDBServicing = TMDBService()) {
        dataSource = MoviesHomeDataSource(collectionView: collectionView)
        tmdbService = service
    }
    
    func fetchSectionsForView() async {
        await fetch(.popular)
        await fetch(.topRated)
        await fetch(.nowPlaying)
        await fetch(.upcoming)
        dataSource.setData(sections)
    }
    
    private func fetch(_ endpoint: TMDBEndpoint) async {        
        do {
            let list = try await tmdbService.fetch(MovieList.self, from: endpoint)
            if let list = list {
                let section = Section(type: endpoint, items: list.results.map { WrappedMovie(movie: $0) })
                self.sections.append(section)
            }
        } catch {
            print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
        }
    }
}
