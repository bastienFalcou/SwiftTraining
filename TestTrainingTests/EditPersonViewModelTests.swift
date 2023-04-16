//  Created by Bastien Falcou on 4/10/23.

import XCTest
@testable import TestTraining

// Reference: https://github.com/nanocba/SwiftUITestbed/blob/main/SwiftUITestbedTests/Listings/ListingsViewModelTests.swift
final class EditPersonViewModelTests: XCTestCase {
    func testPerson() {
        let person = Person(name: "Bastien", language: "Swift")
        let viewModel = EditPersonViewModel(person: person)
        XCTAssertEqual(viewModel.person.name, person.name)
        XCTAssertEqual(viewModel.person.language, person.language)
    }

    func testEdit() {
        let person = Person(name: "Bastien", language: "Swift")
        let viewModel = EditPersonViewModel(person: person)

        runAsyncTest {
            XCTAssertFalse(viewModel.state.updatedOnServer)
            await viewModel.updatePersonOnServer()
            XCTAssertTrue(viewModel.state.updatedOnServer)
        }
    }
}

extension XCTestCase {
    func runAsyncTest(
        named testName: String = #function,
        in file: StaticString = #file,
        at line: UInt = #line,
        withTimeout timeout: TimeInterval = 10,
        test: @escaping () async throws -> Void
    ) {
        var thrownError: Error?
        let errorHandler = { thrownError = $0 }
        let expectation = expectation(description: testName)

        Task {
            do {
                try await test()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        if let error = thrownError {
            XCTFail(
                "Async error thrown: \(error)",
                file: file,
                line: line
            )
        }
    }
}
