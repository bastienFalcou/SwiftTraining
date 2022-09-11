//  Created by Bastien Falcou on 8/27/22.

import Foundation
import Combine

final class ViewModel: ObservableObject {
    private let apiClient: APIClient
    private let apiCallPath = "9e528b12fd1a45a7ff4e4691adcddf10/raw/5ec8ce76460e8f29c9b0f99f3bf3450b06696482/people.json"

    @Published var people: [Person]?
    @Published var error: Error?

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func makeAPICallLegacy() {
        apiClient.perform(request: .get,
                          path: apiCallPath,
                          properties: nil) { [weak self] (result: Result<People, Error>) -> Void in
            DispatchQueue.main.async { // TODO: this should be handled more generic
                switch result {
                case .success(let response):
                    self?.people = response.people
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }

    @MainActor
    func makeAPICallAsyncAwait() {
        Task {
            do {
                let people: People = try await apiClient.perform(request: .get,
                                                                 path: apiCallPath,
                                                                 properties: nil)
                self.people = people.people
            } catch {
                self.error = error
            }
        }
    }
}
