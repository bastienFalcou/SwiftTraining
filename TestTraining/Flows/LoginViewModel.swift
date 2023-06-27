//  Created by Bastien Falcou on 4/9/23.

import Foundation
import SwiftUI

final class LoginViewModel: ObservableViewModel {
    var state: State
        
    enum Event {
        case submit(Person)
    }
    
    struct State: Equatable {
        var login: String
        var password: String
        var error: Error?
        
        static func == (lhs: LoginViewModel.State, rhs: LoginViewModel.State) -> Bool {
            lhs.login == rhs.login && lhs.password == rhs.password
        }
    }
    
    init() {
        state = State(login: "", password: "")
    }
    
    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> where Value : Equatable {
        Binding {
            self.state[keyPath: keyPath]
        } set: {
            self.state[keyPath: keyPath] = $0
        }
    }
}
