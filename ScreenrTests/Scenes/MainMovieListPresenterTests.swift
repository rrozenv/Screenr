
import XCTest
@testable import Screenr

class MainMovieListPresenterTests: XCTestCase {
    
    var testingClass: MainMovieListPresenter!
    
    override func setUp() {
        super.setUp()
        setupMainMovieListPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupMainMovieListPresenter() {
        testingClass = MainMovieListPresenter()
    }
    
    //MARK: - Testing Doubles
    
    class MainMovieListDisplayLogicSpy: MainMovieListDisplayLogic {
        var displayMovieListCalled = false
        
        func displayMoviesFromNetwork(viewModel: MainMovieList.ViewModel) {
            displayMovieListCalled = true
        }
    }
    
    //MARK: - Tests
    
    func testPresentMovieListShouldAskViewControllerToDisplayMovies() {
        // Given
        let mainMovieListDisplayLogicSpy = MainMovieListDisplayLogicSpy()
        testingClass.viewController = mainMovieListDisplayLogicSpy
        let movies = MainMovieList.Seeds.genearteTestMovies()
        let response = MainMovieList.Response(movies: movies)
        
        // When
        testingClass.presentMovieList(response: response)
        
        // Then
        XCTAssertTrue(mainMovieListDisplayLogicSpy.displayMovieListCalled, "presentFetchedGists(response:) should ask the view controller to display gists")
    }
    
}
