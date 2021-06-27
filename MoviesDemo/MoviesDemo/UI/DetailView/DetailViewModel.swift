//
//  DetailViewModel.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/11/21.
//

import UIKit

class DetailViewModel {
    enum CellType: Hashable {
        case hero(Movie)
        case overview(String)
        case cast(CastMember)
        case crew(CrewMember)
        case recommendation(Movie)
    }
    
    struct Section: Hashable {
        var items: [CellType]
        let id = UUID()
        
        var sectionTitle: String {
            switch items.first {
            case .overview:
                return "Overview"
            case .cast:
                return "Cast"
            case .crew:
                return "Crew"
            case .recommendation:
                return "You might like"
            default:
                return ""
            }
        }
    }
    
    var movie: Movie
    var credits: Credits?
    var recommendations: [Movie] = []
    let service = TMDBService()
    var activeGroup = DispatchGroup()
    var dataSource: DetailViewDataSource! {
        didSet {
            fetchDetails()
        }
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func performRequests() {
        fetchDetails()
        fetchCredits()
        fetchRecommendations()
    }
    
    private func fetchDetails() {
        activeGroup.enter()
        service.fetch(Movie.self, from: .movieDetail(movie.id)) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movie = movie
            case .failure(let error):
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
            }
            self?.activeGroup.leave()
        }
        
        
        activeGroup.notify(queue: .main) { [self] in
            
            let hero = Section(items: [.hero(movie)])
            let overview = Section(items: [.overview(movie.overview)])
            let cast = Section(items: credits?.cast.filter({ $0.photoPath != nil }).compactMap { CellType.cast($0) } ?? [])
            let crew = Section(items: credits?.crew.filter({ $0.photoPath != nil }).compactMap { CellType.crew($0) } ?? [])
            let recommendations = Section(items: self.recommendations.compactMap { CellType.recommendation($0) })
            
            self.dataSource.updateData(with: [hero, overview, cast, crew, recommendations])
        }
    }
    
    private func fetchCredits() {
        activeGroup.enter()
        service.fetch(Credits.self, from: .movieCredits(movie.id)) { [weak self] result in
            switch result {
            case .success(let credits):
                self?.credits = credits
            case .failure(let error):
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
            }
            self?.activeGroup.leave()
        }
    }
    
    private func fetchRecommendations() {
        activeGroup.enter()
        service.fetch(MovieList.self, from: .movieRecommendations(movie.id)) { [weak self] result in
            switch result {
            case .success(let list):
                self?.recommendations = list.results
            case .failure(let error):
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
            }
            self?.activeGroup.leave()
        }
    }
}
