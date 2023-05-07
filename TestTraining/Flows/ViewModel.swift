//  Created by Bastien Falcou on 3/6/23.

import Foundation
import SwiftUI     // Question: Is that an anti-pattern?

final class ViewModel: ObservableViewModel {
    typealias Event = ViewModel     // Question: Why did I need to declare this?

    struct State: Equatable {
        var people: [Person]?
        var error: Error?

        static func == (lhs: ViewModel.State, rhs: ViewModel.State) -> Bool {
            lhs.people?.lazy.map(\.id) == rhs.people?.lazy.map(\.id)
                && String(reflecting: lhs.error) == String(reflecting: rhs.error)
        }
    }

    private let apiCallPath = "9e528b12fd1a45a7ff4e4691adcddf10/raw/5ec8ce76460e8f29c9b0f99f3bf3450b06696482/people.json"
    private let apiClient: APIClient

    @Published private(set) var state: State = .init()

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    @MainActor
    func refresh() async {
        await apiClient.perform(request: .get,
                                path: apiCallPath,
                                properties: nil,
                                completion: { (result: Result<People, Error>, cache: Bool) in
            switch (result) {
            case (.success(let people)):
                print("Is from cache: \(cache)")
                self.state.people = people.people
            case (.failure(let error)):
                self.state.error = error
            }
        })
    }

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> where Value : Equatable {
        Binding {
            self.state[keyPath: keyPath]
        } set: {
            self.state[keyPath: keyPath] = $0
        }
    }
}
