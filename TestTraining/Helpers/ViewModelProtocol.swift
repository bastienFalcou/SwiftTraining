//  Created by Bastien Falcou on 3/6/23.

import Foundation
import SwiftUI

@dynamicMemberLookup
public protocol ViewModelProtocol: ObservableObject, ViewModelObserver {
    associatedtype State: Equatable
    var state: State { get }
    func binding<Value: Equatable>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value>
}

public extension ViewModelProtocol {
    typealias KeyPath<Value: Equatable> = ReferenceWritableKeyPath<Self, Value>
    typealias StateKeyPath<Value: Equatable> = WritableKeyPath<State, Value>
}

public extension ViewModelProtocol {
    subscript<StateProperty>(dynamicMember keyPath: Swift.KeyPath<State, StateProperty>) -> StateProperty {
        state[keyPath: keyPath]
    }

    func binding<Value>(_ keyPath: KeyPath<Value>) -> Binding<Value> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}

public extension ViewModelProtocol {
    func observe<ViewModel: ObservableViewModel>(_ viewModelType: ViewModel.Type, closure: @escaping (ViewModel.Event) -> Void) {
        EventManager.shared.add(observer: self, viewModel: viewModelType, closure: closure)
    }

    func unobserve<ViewModel: ObservableViewModel>(_ viewModelType: ViewModel.Type) {
        EventManager.shared.remove(observer: self, viewModel: viewModelType)
    }

    func unobserve() {
        EventManager.shared.remove(observer: self)
    }
}
