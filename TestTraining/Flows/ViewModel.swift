//  Created by Bastien Falcou on 8/27/22.

import Foundation
import Combine

final class ViewModel: ObservableObject {
    private let apiClient: APIClient

    @Published var people: [Person]?

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func makeAPICall() {
        apiClient.perform(request: .get,
                          path: "9e528b12fd1a45a7ff4e4691adcddf10/raw/5ec8ce76460e8f29c9b0f99f3bf3450b06696482/people.json",
                          properties: nil) { [weak self] (result: Result<People, Error>) -> Void in
            switch result {
            case .success(let response):
                self?.people = response.people
            case .failure(let error):
                print(error)
            }
        }
    }
}
