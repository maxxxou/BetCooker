//
//  BetCookerTests.swift
//  BetCookerTests
//
//  Created by Guest User on 22/05/2025.
//

import XCTest
import SwiftUI
@testable import BetCooker

final class BetCookerTests: XCTestCase {
    
    @MainActor
    func testFetchOdds() {
        let expectation = expectation(description: "fetchOdds validation")

        APIService.shared.fetchOdds { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    XCTAssertNotNil(data)
                    XCTAssertFalse(data.isEmpty)
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    @MainActor
    func testFetchScores() {
        let expectation = expectation(description: "fetchScores validation")

        APIService.shared.fetchScores { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    XCTAssertNotNil(data)
                    XCTAssertFalse(data.isEmpty)
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    @MainActor
    func testFetchLogoFromTeamName() {
        let expectation = expectation(description: "fetchLogoFromTeamName validation")
        APIService.shared.fetchLogoFromTeamName("Real%20Madrid") { result in
            switch result {
            case .success(let message):
                XCTAssertNotNil(message)
                XCTAssertFalse(message.isEmpty)
                XCTAssertEqual(message, "https://r2.thesportsdb.com/images/media/team/badge/vwvwrw1473502969.png")
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    @MainActor
    func testFetchLogoFromTeamNameBad() {
        let expectation = expectation(description: "fetchLogoFromTeamName validation")
        APIService.shared.fetchLogoFromTeamName("caca") { result in
            switch result {
            case .success(let message):
                XCTAssertNotNil(message)
                XCTAssertFalse(message.isEmpty)
                XCTAssertEqual(message, "caca")
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    @MainActor
    func testHexConversion() {
        let color = Color(hex: "#FF0000")
        
        let uiColor = UIColor(color)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        XCTAssertEqual(red, 1.0, accuracy: 0.01)
        XCTAssertEqual(green, 0.0, accuracy: 0.01)
        XCTAssertEqual(blue, 0.0, accuracy: 0.01)
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01)
    }
}
