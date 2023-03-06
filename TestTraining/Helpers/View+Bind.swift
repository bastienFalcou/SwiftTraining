//  Created by Bastien Falcou on 3/6/23.

import SwiftUI

extension View {
    func bind<ModelValue: Bindable, ViewValue: Bindable>(
        model modelValue: ModelValue,
        to viewValue: ViewValue
    ) -> some View where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
        modifier(_Bind(modelValue: modelValue, viewValue: viewValue))
    }
}

private struct _Bind<ModelValue: Bindable, ViewValue: Bindable>: ViewModifier
    where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
    let modelValue: ModelValue
    let viewValue: ViewValue

    func body(content: _Bind.Content) -> some View {
        content
            .onChange(of: modelValue.wrappedValue) {
                guard self.viewValue.wrappedValue != $0
                else { return }
                self.viewValue.wrappedValue = $0
            }
            .onChange(of: viewValue.wrappedValue) {
                guard self.modelValue.wrappedValue != $0
                else { return }
                self.modelValue.wrappedValue = $0
            }
    }
}
