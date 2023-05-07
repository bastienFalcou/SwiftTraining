//  Created by Bastien Falcou on 8/27/22.

import Foundation
import Combine

final class LegacyViewModel: ObservableObject {
    private let apiClient: APIClient
    private let apiCallPath = "9e528b12fd1a45a7ff4e4691adcddf10/raw/5ec8ce76460e8f29c9b0f99f3bf3450b06696482/people.json"

    // @Published: property wrapper to create observable objects, SwiftUI automatically re-invoke any "body" func relying on it
    @MainActor @Published var people: [Person]?
    @MainActor @Published var error: Error?

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    @MainActor
    func makeAPICallLegacy() {
        apiClient.perform(request: .get,
                          path: apiCallPath,
                          properties: nil) { [weak self] (result: Result<People, Error>) -> Void in
                switch result {
                case .success(let response):
                    self?.people = response.people
                case .failure(let error):
                    self?.error = error
                }
        }
    }

    @MainActor
    func makeAPICallAsyncAwait() async {
        do {
            let response: People = try await apiClient.perform(request: .get,
                                                               path: apiCallPath,
                                                               properties: nil)
            self.people = response.people
        } catch {
            self.error = error
        }
    }
}
