//  Created by Bastien Falcou on 4/9/23.

import SwiftUI

final class EditPersonViewModel: ViewModelProtocol, ObservableViewModel {
    enum Event {
        case cancel
        case submit(Person)
    }

    struct State: Equatable {
        let id: String
        var name: String
        var language: String
        var error: Error?
        var updatedOnServer = false // TODO: Used for testing of unit tests

        static func == (lhs: EditPersonViewModel.State, rhs: EditPersonViewModel.State) -> Bool {
            lhs.id == rhs.id
        }
    }

    @Published private(set) var state: State

    var person: Person {
        .init(
            name: state.name,
            language: state.language
        )
    }

    init(person: Person) {
        state = .init(
            id: person.id.uuidString,
            name: person.name,
            language: person.language ?? ""
        )

        // TODO: Observe state changes...
        observe(EditPersonViewModel.self) { event in
            switch event {
            case .submit(let person):
                do {
                    try self.validateInput(person)
                    self.state.name = person.name
                    self.state.language = person.language ?? ""
                } catch {
                    self.state.error = error
                }
            case .cancel:
                print("operation was cancelled")
            }
        }
    }

    // TODO: Used for testing of unit tests
    func updatePersonOnServer() async throws {
        state.updatedOnServer = false
        try await Task.sleep(nanoseconds: 3_000_000_000)
        state.updatedOnServer = true
    }

    func reset() {
        state.error = nil
    }

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> where Value : Equatable {
        Binding {
            self.state[keyPath: keyPath]
        } set: {
            self.state[keyPath: keyPath] = $0
        }
    }
}

// TODO: Validation logic...
extension EditPersonViewModel {
    enum ValidationError: Error {
        case incorrectName
        case incorrectLanguage
    }

    private func validateInput(_ person: Person) throws {
        guard !person.name.isEmpty else {
            throw ValidationError.incorrectName
        }
        guard let language = person.language?.uppercased(), ["Swift", "Objective-C", "Kotlin", "C++", "Java"].map({ $0.uppercased() }).contains(language) else {
            throw ValidationError.incorrectLanguage
        }
    }
}
