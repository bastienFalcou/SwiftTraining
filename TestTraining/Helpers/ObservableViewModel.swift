//  Created by Bastien Falcou on 3/6/23.

import Foundation

public protocol ObservableViewModel: ViewModelProtocol {
    associatedtype Event
}

extension ObservableViewModel {
    func send(_ event: Event) {
        EventManager.shared.notify(viewModel: self, event: event)
    }
}
