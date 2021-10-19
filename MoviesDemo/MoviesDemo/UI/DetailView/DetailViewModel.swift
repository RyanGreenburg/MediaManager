//
//  DetailViewModel.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/11/21.
//

import UIKit

@MainActor
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
    var dataSource: DetailViewDataSource!
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func performRequests() async {
        await fetchDetails()
        await fetchCredits()
        await fetchRecommendations()
        buildSections()
    }
    
    private func fetchDetails() async {
        do {
            guard let movie = try await service.fetch(Movie.self, from: .movieDetail(movie.id)) else {
                return
            }
            self.movie = movie
        } catch {
            print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    private func buildSections() {
        let hero = Section(items: [.hero(movie)])
        let overview = Section(items: [.overview(movie.overview)])
        let cast = Section(items: credits?.cast.filter({ $0.photoPath != nil }).compactMap { CellType.cast($0) } ?? [])
        let crew = Section(items: credits?.crew.filter({ $0.photoPath != nil }).compactMap { CellType.crew($0) } ?? [])
        let recommendations = Section(items: self.recommendations.compactMap { CellType.recommendation($0) })
        
        self.dataSource.updateData(with: [hero, overview, cast, crew, recommendations])
    }
    
    private func fetchCredits() async {
        do {
            guard let credits = try await service.fetch(Credits.self, from: .movieCredits(movie.id)) else {
                return
            }
            self.credits = credits
        } catch {
            print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    private func fetchRecommendations() async {
        do {
            guard let recommendations = try await service.fetch(MovieList.self, from: .movieRecommendations(movie.id)) else {
                return
            }
            self.recommendations = recommendations.results
        } catch {
            print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
        }
    }
}
