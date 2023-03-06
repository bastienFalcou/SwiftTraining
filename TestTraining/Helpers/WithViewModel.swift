//
//  WithViewModel.swift
//  TestTraining
//
//  Created by Bastien Falcou on 3/6/23.
//

import SwiftUI

public struct WithViewModel<ViewModel: ViewModelProtocol, Content: View>: View {
    @StateObject var viewModel: ViewModel
    let content: (ViewModel) -> Content

    private var bindings: (ViewModel) -> AnyView = { _ in EmptyView().eraseToAnyView() }

    public init(_ viewModel: @autoclosure @escaping () -> ViewModel, @ViewBuilder content: @escaping (ViewModel) -> Content) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.content = content
    }

    public var body: some View {
        EquatableContent(viewModel: viewModel, content: content, state: viewModel.state)
            .equatable()

        bindings(viewModel)
    }

    public func bind<Value: Equatable>(_ keyPath: ViewModel.KeyPath<Value>, to value: Value) -> Self {
        bind(.viewModel(keyPath), to: Binding.constant(value))
    }

    public func bind<Value: Equatable>(_ keyPath: ViewModel.StateKeyPath<Value>, to value: Value) -> Self {
        bind(.state(keyPath), to: Binding.constant(value))
    }

    public func bind<Value: Bindable>(_ keyPath: ViewModel.KeyPath<Value.Value>, to value: Value) -> Self where Value.Value: Equatable {
        bind(.viewModel(keyPath), to: value)
    }

    public func bind<Value: Bindable>(_ keyPath: ViewModel.StateKeyPath<Value.Value>, to value: Value) -> Self where Value.Value: Equatable {
        bind(.state(keyPath), to: value)
    }

    private func bind<Value: Bindable>(_ keyPath: BindingType<Value.Value>, to value: Value) -> Self where Value.Value: Equatable {
        var newValue = self
        newValue.bindings = { viewModel in
            bindings(viewModel)
                .bind(model: keyPath.binding(from: viewModel), to: value)
                .eraseToAnyView()
        }
        return newValue
    }

    private enum BindingType<Value: Equatable> {
        case viewModel(ReferenceWritableKeyPath<ViewModel, Value>)
        case state(WritableKeyPath<ViewModel.State, Value>)

        func binding(from viewModel: ViewModel) -> Binding<Value> {
            switch self {
            case let .viewModel(refKeyPath): return viewModel.binding(refKeyPath)
            case let .state(stateKeyPath): return viewModel.binding(stateKeyPath)
            }
        }
    }

    private struct EquatableContent: View, Equatable {
        @ObservedObject var viewModel: ViewModel
        let content: (ViewModel) -> Content
        let state: ViewModel.State

        var body: some View {
            content(viewModel)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.state == rhs.state
        }
    }
}

private extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(erasing: self)
    }
}
