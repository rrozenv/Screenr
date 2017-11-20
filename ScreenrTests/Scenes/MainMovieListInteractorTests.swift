
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
        let deferredPromise = Promise<[Movie_R]>.pending()
        
        override func fetchCurrentlyPlayingMovies(_ resource: Resource<[Movie_R]>, completion: @escaping ([Movie_R], Error?) -> Void) {
            let movies = MainMovieList.Seeds.genearteTestMovies()
            fetchCalled = true
            completion(movies, nil)
        }
    }
    
    class MainMovieListPresentationLogicSpy: MainMovieListPresentationLogic {
        var presentMovieListCalled = false
        
        func presentMovieList(response: MainMovieList.Response) {
            presentMovieListCalled = true
        }
    }
    
    // MARK: Tests
    
    func testLoadMoviesShouldAskWorkerToLoadMovies() {
        // Given
        let mainMovieListWorkerSpy = MainMovieListWorkerSpy()
        testClass.moviesWorker = mainMovieListWorkerSpy

        // When
        testClass.fetchMoviesFromNetwork(for: "10016")
        
        // Then
        XCTAssertTrue(mainMovieListWorkerSpy.fetchCalled, "fetchGists(request:) should ask the worker to fetch gists")
    }
    
    func testLoadMoviesShouldAskPresenterToFormatMovies() {
        // Given
        let mainMovieListWorkerSpy = MainMovieListWorkerSpy()
        testClass.moviesWorker = mainMovieListWorkerSpy
        let mainMovieListPresentationLogicSpy = MainMovieListPresentationLogicSpy()
        testClass.presenter = mainMovieListPresentationLogicSpy
        
        // When
        testClass.fetchMoviesFromNetwork(for: "10016")
        
        // Then
        XCTAssertTrue(mainMovieListPresentationLogicSpy.presentMovieListCalled, "fetchGists(request:) should ask the presenter to format gists")
    }
    
}
