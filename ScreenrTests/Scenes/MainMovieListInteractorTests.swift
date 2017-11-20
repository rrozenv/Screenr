//
//  MainMovieListInteractorTests.swift
//  ScreenrTests
//
//  Created by Robert Rozenvasser on 11/20/17.
//  Copyright © 2017 GoKid. All rights reserved.
//

@testable import Screenr
import XCTest
import PromiseKit

class MainMovieListInteractorTests: XCTestCase {
    
    var testClass: MainMovieListInteractor!
    
    override func setUp() {
        super.setUp()
        setupInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupInteractor() {
        testClass = MainMovieListInteractor()
    }
    
    // MARK: Test doubles
    
    class MainMovieListWorkerSpy: MovieWorker {
        var fetchCalled = false
        
        override func fetchCurrentlyPlayingMovies(_ resource: Resource<[Movie_R]>) -> Promise<[Movie_R]> {
            let movie = Movie_R()
            movie.movieID = "100"
            movie.year = "1999"
            let movies = [movie]
            fetchCalled = true
            return Promise { fullfill, _ in
                fullfill(movies)
            }
        }
    }
    
    // MARK: Tests
    
    func testLoadMoviesShouldAskWorkerToLoadMovies() {
        // Given
        let mainMovieListWorkerSpy = MainMovieListWorkerSpy()
        testClass.moviesWorker = mainMovieListWorkerSpy
        
        // When
        testClass.loadMoviesFromNetwork(for: "10016")
        
        // Then
        XCTAssertTrue(mainMovieListWorkerSpy.fetchCalled, "fetchGists(request:) should ask the worker to fetch gists")
    }
    
}
