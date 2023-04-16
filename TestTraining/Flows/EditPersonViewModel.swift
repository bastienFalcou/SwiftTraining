//  Created by Bastien Falcou on 4/9/23.

import SwiftUI

final class EditPersonViewModel: ViewModelProtocol, ObservableViewModel {
    enum Event {
        case cancel
        case formInputChange
        case submit(Person)
    }

    struct State: Equatable {
        let id: String
        var name: String
        var language: String
        var error: Error?
        var updatedOnServer = false // Used for testing of unit tests

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

        observe(EditPersonViewModel.self) { event in
            switch event {
            case .formInputChange:
                do {
                    try self.validateInput(self.person)
                    self.state.name = self.person.name
                    self.state.language = self.person.language ?? ""
                    self.state.error = nil
                } catch {
                    self.state.error = error
                }
            default:
                break
            }
        }
    }

    // Used for testing of unit tests
    @MainActor func updatePersonOnServer() async {
        state.updatedOnServer = false
        try! await Task.sleep(nanoseconds: 250_000_000)
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

extension EditPersonViewModel {
    enum ValidationError: Error, LocalizedError {
        case nameEmpty
        case languageIncorrect

        var errorDescription: String {
            switch self {
            case .nameEmpty: return "The name cannot be empty"
            case .languageIncorrect: return "This is not a valid programming language"
            }
        }
    }

    private func validateInput(_ person: Person) throws {
        guard !person.name.isEmpty else {
            throw ValidationError.nameEmpty
        }
        guard let language = person.language?.uppercased(),
            ["Swift", "Objective-C", "Kotlin", "C++", "Java"].map({ $0.uppercased() }).contains(language) else {
                throw ValidationError.languageIncorrect
        }
    }
}
