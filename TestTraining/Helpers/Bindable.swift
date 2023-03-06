//  Created by Bastien Falcou on 3/6/23.

import SwiftUI

public protocol Bindable {
    associatedtype Value
    var wrappedValue: Value { get nonmutating set }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension AccessibilityFocusState: Bindable { }

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension AccessibilityFocusState.Binding: Bindable { }

extension AppStorage: Bindable { }

extension Binding: Bindable { }

extension FocusedBinding: Bindable { }

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension FocusState: Bindable { }

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension FocusState.Binding: Bindable { }

extension SceneStorage: Bindable { }

extension State: Bindable { }
