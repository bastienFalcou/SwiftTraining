//  Created by Bastien Falcou on 8/27/22.

import Foundation
import Combine

final class ViewModel: ObservableObject {
    private let apiClient: APIClient
    private let apiCallPath = "9e528b12fd1a45a7ff4e4691adcddf10/raw/5ec8ce76460e8f29c9b0f99f3bf3450b06696482/people.json"

    // @Published: property wrapper to create observable objects, SwiftUI automatically re-invoke any "body" func relying on it
    @Published var people: [Person]?
    @Published var error: Error?

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

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

    // @MainActor: global actor that uses the main queue for executing its work
    // Question: Is it best way to ensure UI is updated on main thread, after 'apiClient' has done API call + parsing on a background thread?
    // ...other option, make '@MainActor @Published var people: [Person]?'
    // ...or is it not needed at all, since the Task makes the bridge between async and sync?
    @MainActor
    func makeAPICallAsyncAwait() {
        // Task: unit of asynchronous work, needed around 'await' (itself needed whenever calling any func marked 'async')
        // Bridge between synchronous, main thread-bound UI code and any background operations e.g. used to fetch/process data that UI is rendering
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
