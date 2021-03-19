//
//  TestsSharedPackage.swift
//  TestsSharedPackage
//
//  Created by Stijn Willems on 19/03/2021.
//

import XCTest
@testable import SharedPackage

class SquareTests: XCTestCase {
    var square: Square!

    override func setUp() {
        super.setUp()
        square = .init(.nobody)
    }
    func test_init() {
        XCTAssertEqual(square.ownedBy, .nobody)
    }
    
    func test_bindable_status() {
        var result = [Square.OccupiedBy]()
        let cancellable = square
            .$ownedBy
            .collect(2)
            .sink { result = $0}
        square.ownedBy = .home
        cancellable.cancel()
        XCTAssertEqual(result, [.nobody, .home])
    }
}