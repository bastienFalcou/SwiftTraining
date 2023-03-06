//  Created by Bastien Falcou on 3/6/23.

import Foundation

final class EventManager {
    static let shared: EventManager = .init()

    private var registrations: [any RegistrationProtocol] = []

    func add<T: ViewModelObserver, ViewModel: ObservableViewModel>(observer: T, viewModel viewModelType: ViewModel.Type, closure: @escaping (ViewModel.Event) -> Void) {
        guard !exists(observer: observer, viewModelType: viewModelType) else { return }
        registrations.append(Registration<T, ViewModel>(parent: observer, closure: closure))
    }

    func remove<T: ViewModelObserver, ViewModel: ObservableViewModel>(observer: T, viewModel viewModelType: ViewModel.Type) {
        registrations.removeAll(where: matching(observer: observer, viewModelType: viewModelType))
    }

    func remove<T: ViewModelObserver>(observer: T) {
        registrations.removeAll(where: matching(observer: observer))
    }

    func notify<ViewModel: ObservableViewModel>(viewModel: ViewModel, event: ViewModel.Event) {
        for registration in registrations.filter(matching(viewModelType: type(of: viewModel))) {
            registration.notify(viewModel, event: event)
        }
    }

    private func exists<T: ViewModelObserver, ViewModel: ObservableViewModel>(observer: T, viewModelType: ViewModel.Type) -> Bool {
        registrations.contains(where: matching(observer: observer, viewModelType: viewModelType))
    }

    private func matching<T: ViewModelObserver, ViewModel: ObservableViewModel>(observer: T, viewModelType: ViewModel.Type) -> (any RegistrationProtocol) -> Bool {
        { self.matching(observer: observer)($0) && self.matching(viewModelType: viewModelType)($0) }
    }

    private func matching<T: ViewModelObserver>(observer: T) -> (any RegistrationProtocol) -> Bool {
        { $0.parent.objectIdentifier == observer.objectIdentifier }
    }

    private func matching<ViewModel: ObservableViewModel>(viewModelType: ViewModel.Type) -> (any RegistrationProtocol) -> Bool {
        { $0.canHandle(viewModelType) }
    }
}

private protocol RegistrationProtocol {
    associatedtype ViewModel: ObservableViewModel
    associatedtype Parent: ViewModelObserver
    var parent: Parent { get }
    var closure: (ViewModel.Event) -> Void { get }
}

extension RegistrationProtocol {
    func canHandle<ViewModel: ObservableViewModel>(_ viewModelType: ViewModel.Type) -> Bool {
        viewModelType == ViewModel.self
    }

    func notify<ViewModel: ObservableViewModel>(_ viewModel: ViewModel, event viewModelEvent: ViewModel.Event) {
        guard let event = event(viewModelEvent) else { return }
        closure(event)
    }

    private func event<Event>(_ event: Event) -> ViewModel.Event? {
        event as? ViewModel.Event
    }
}

private struct Registration<Parent: ViewModelObserver, ViewModel: ObservableViewModel>: RegistrationProtocol {
    let parent: Parent
    let closure: (ViewModel.Event) -> Void
}
