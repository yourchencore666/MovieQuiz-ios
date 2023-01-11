//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Юрченко Артем on 31.10.2022.
//

import XCTest
@testable import MovieQuiz

class MovieQuizUITests: XCTestCase {
    
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
        
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let indexLabel = app.staticTexts["Index"] // находим лейбл счетчика вопросов
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10") // проверяем что текст лейбла поменялся от дефолтного
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
    }
    
    func testNoButton() {
        
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        app.buttons["No"].tap() // находим кнопку `Да` и нажимаем её
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let indexLabel = app.staticTexts["Index"] // находим лейбл счетчика вопросов
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10") // проверяем что текст лейбла поменялся от дефолтного
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
    }
    
    func testShowAlert() {
        for _ in 1...10 {
            app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её 10 раз
            sleep(3)
        }
        
        let alert = app.alerts["result_alert"]
        
        XCTAssertTrue(alert.exists) //алерт показан?
        XCTAssertTrue(alert.label == "Этот раунд окончен!") // лейбл соответствует?
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз") // текст кнопки соответсвтует?

    }
    
    func testDismisAlert() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        let alert = app.alerts["result_alert"]
        
        alert.buttons.firstMatch.tap()
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
        
    }
    
    
}
