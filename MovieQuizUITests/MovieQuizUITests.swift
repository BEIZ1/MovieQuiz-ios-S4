import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        sleep(3)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        sleep(3)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testFinishGame() {
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        let numbers = indexLabel.label.split(separator: "/")
        let questionsCount = Int(numbers[1]) ?? 10
        for _ in 1...questionsCount {
            sleep(2)
            app.buttons["No"].tap()
        }
        sleep(1)
        let alert = app.alerts["Alert"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testRestartGame() {
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        let numbers = indexLabel.label.split(separator: "/")
        let questionsCount = Int(numbers[1]) ?? 10
        for _ in 1...questionsCount {
            sleep(2)
            app.buttons["No"].tap()
        }
        sleep(1)
        let alert = app.alerts["Alert"]
        alert.buttons.firstMatch.tap()
        sleep(3)
        let indexLabelNew = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabelNew.label == "1/\(questionsCount)")
    }
}
