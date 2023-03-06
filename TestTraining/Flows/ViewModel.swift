//  Created by Bastien Falcou on 3/6/23.

import Foundation
import SwiftUI     // Question: Is that an anti-pattern?

final class ViewModel: ObservableViewModel {
    typealias Event = ViewModel     // Question: Why did I need to declare this?

    struct State: Equatable {
        static func == (lhs: ViewModel.State, rhs: ViewModel.State) -> Bool {     // Question: Do I need this?
            return lhs.people?.hashValue == rhs.people?.hashValue
        }

        let apiCallPath = "9e528b12fd1a45a7ff4e4691adcddf10/raw/5ec8ce76460e8f29c9b0f99f3bf3450b06696482/people.json"     // Question: Should constants be in 'State'?
        var apiClient: APIClient
        var people: [Person]?
        var error: Error?
    }

    @Published private(set) var state: State

    init(apiClient: APIClient) {
        state = State(apiClient: apiClient)
    }

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }

    @MainActor
    func makeAPICallAsyncAwait() async {
        do {
            let people: People = try await self.state.apiClient.perform(request: .get,
                                                                        path: self.state.apiCallPath,
                                                                        properties: nil)
            self.state.people = people.people
        } catch {
            self.state.error = error
        }
    }
}
