//
//  NetworkServicingTests.swift
//  MoviesDemoTests
//
//  Created by RYAN GREENBURG on 10/19/21.
//

import XCTest
@testable import MoviesDemo

class NetworkServicingTests: XCTestCase {

    var mockService: MockService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockService()
    }

    func testSuccessfulRequest() async throws {
        let url = try XCTUnwrap(Bundle.main.url(forResource: "MockMovieListJSON", withExtension: "json"))
        let data = try await mockService.perform(URLRequest(url: url))
        XCTAssertNotNil(data)
    }
    
//    func testFailedRequest() async throws {
//        let emptyURL = try XCTUnwrap(URL(string: "http://test.fake.url"))
//        XCTAssertThrowsError(try await mockService.perform(URLRequest(url: emptyURL)))
//    }
}

class MockService: NetworkServicing {
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
