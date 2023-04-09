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
    }

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> where Value : Equatable {
        Binding {
            self.state[keyPath: keyPath]
        } set: {
            self.state[keyPath: keyPath] = $0
        }
    }
}
