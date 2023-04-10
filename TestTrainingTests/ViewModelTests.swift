//  Created by Bastien Falcou on 4/10/23.

import Foundation
import XCTest

final class ViewModelTests: XCTestCase {
    func testSearch() async throws {
        let allPersons = allPersons
        let viewModel = ViewModel(apiClient: <#T##<<error type>>#>)((allListings: allListings)
        viewModel.searchTerm = "Listing 1"

        let value = try await viewModel.assertThrowing(
            try await viewModel.search(),
            beforeSuspension: {
                $0.searching = true
            },
            afterSuspension: {
                $0.searching = false
            }
        )
        XCTAssertEqual(value, [allListings[0]])
    }

    func testFetchAllListings() async {
        let allPersons = allPersons
        let viewModel = ListingsViewModel(allListings: [])

        await viewModel.assert(
            await viewModel.fetchAllListings(),
            beforeSuspension: {
                $0.loading = true
            },
            afterSuspension: {
                $0.loading = false
                $0.allListings = allListings
                $0.listings = allListings
            }
        )
    }

    func testPerformSearch() async throws {
        let allPersons = allPersons
        let viewModel = ListingsViewModel(allListings: allListings)

        try await viewModel.assertThrowing(
            try await viewModel.performSearch("L"),
            beforeSuspension: {
                $0.searchTerm = "L"
            },
            afterSuspension: {
                $0.listings = allListings
            }
        )

        try await viewModel.assertThrowing(
            try await viewModel.performSearch("Li"),
            beforeSuspension: {
                $0.searchTerm = "Li"
            },
            afterSuspension: {
                $0.listings = allListings
            }
        )

        try await viewModel.assertThrowing(
            try await viewModel.performSearch("Listing 1"),
            beforeSuspension: {
                $0.searchTerm = "Listing 1"
            },
            afterSuspension: {
                $0.listings = [allListings[0]]
            }
        )
    }

    var allPersons: [Person] {
        [
            Person(name: "Bastien", language: "Swift"),
            Person(name: "Dante", language: "Java")
        ]
    }
}
