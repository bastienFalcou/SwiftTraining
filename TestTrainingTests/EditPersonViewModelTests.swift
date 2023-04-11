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

    func testEdit() async throws {
        let person = Person(name: "Bastien", language: "Swift")
        let viewModel = EditPersonViewModel(person: person)

        try await viewModel.assertThrowing(
            try await viewModel.updatePersonOnServer(),
            beforeSuspension: {
                $0.updatedOnServer = false
            },
            afterSuspension: {
                $0.updatedOnServer = true
            }
        )
    }

//    func testFetchAllListings() async {
//        let allPersons = allPersons
//        let viewModel = ListingsViewModel(allListings: [])
//
//        await viewModel.assert(
//            await viewModel.fetchAllListings(),
//            beforeSuspension: {
//                $0.loading = true
//            },
//            afterSuspension: {
//                $0.loading = false
//                $0.allListings = allListings
//                $0.listings = allListings
//            }
//        )
//    }
//
//    func testPerformSearch() async throws {
//        let allPersons = allPersons
//        let viewModel = ListingsViewModel(allListings: allListings)
//
//        try await viewModel.assertThrowing(
//            try await viewModel.performSearch("L"),
//            beforeSuspension: {
//                $0.searchTerm = "L"
//            },
//            afterSuspension: {
//                $0.listings = allListings
//            }
//        )
//
//        try await viewModel.assertThrowing(
//            try await viewModel.performSearch("Li"),
//            beforeSuspension: {
//                $0.searchTerm = "Li"
//            },
//            afterSuspension: {
//                $0.listings = allListings
//            }
//        )
//
//        try await viewModel.assertThrowing(
//            try await viewModel.performSearch("Listing 1"),
//            beforeSuspension: {
//                $0.searchTerm = "Listing 1"
//            },
//            afterSuspension: {
//                $0.listings = [allListings[0]]
//            }
//        )
//    }
//
//    var allPersons: [Person] {
//        [
//            Person(name: "Bastien", language: "Swift"),
//            Person(name: "Dante", language: "Java")
//        ]
//    }
}
