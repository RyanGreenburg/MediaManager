//
//  MoviesHomeViewModelTests.swift
//  MoviesDemoTests
//
//  Created by RYAN GREENBURG on 10/21/21.
//

import XCTest
import UIKit
@testable import MoviesDemo

class MoviesHomeViewModelTests: XCTestCase {

    private var viewModel: MoviesHomeViewModel!
    
    @MainActor override func setUp() {
        super.setUp()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        viewModel = MoviesHomeViewModel(collectionView: collectionView,
                                        service: MockTMDBService())
    }

    @MainActor func testFetchingSectionsForView() async {
        await viewModel.fetchSectionsForView()
        XCTAssertTrue(viewModel.sections.count == 4)
    }
    
}

class MockTMDBService: TMDBServicing, NetworkServicing {
    func fetch<T>(_ type: T.Type, from endpoint: TMDBEndpoint) async throws -> T? where T : Decodable {
        let _ = try XCTUnwrap(endpoint.url)
        let url = try XCTUnwrap(Bundle.main.url(forResource: "MockMovieListJSON", withExtension: "json"))
        do {
            let data = try await perform(URLRequest(url: url))
            guard let object = data.decode(type: type) else {
                throw NetworkError.couldNotUnwrap
            }
            return object
        } catch {
            throw error
        }
    }
    
    func perform(_ request: URLRequest) async throws -> Data {
        guard let url = request.url else { throw NetworkError.badURL }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            throw NetworkError.requestError(error)
        }
    }
}
