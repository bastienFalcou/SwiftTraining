//  Created by Bastien Falcou on 4/9/23.

import SwiftUI

struct EditPersonView: View {
    @Environment(\.dismiss) var dismiss

    let person: Person

    init(person: Person) {
        self.person = person
    }

    var body: some View {
        NavigationView {
            WithViewModel(EditPersonViewModel(person: person)) { viewModel in
                VStack {
                    HStack {
                        Text("Name")
                            .bold()
                            .padding(.leading, 16)
                        Spacer()
                        TextField("Name", text: viewModel.binding(\.name))
                            .onChange(of: viewModel.state.name) { _ in
                                viewModel.send(.formInputChange)
                        }
                    }
                    HStack {
                        Text("Language")
                            .bold()
                            .padding(.leading, 16)
                        Spacer()
                        TextField("Language", text: viewModel.binding(\.language))
                            .onChange(of: viewModel.state.language) { _ in
                                viewModel.send(.formInputChange)
                        }
                    }
                    if let error = viewModel.state.error as? EditPersonViewModel.ValidationError {
                        HStack {
                            Text("An error occured: \(error.errorDescription)")
                                .foregroundColor(.red)
                        }
                    }
                    Spacer()
                }
                .navigationTitle("Edit \(viewModel.name)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewModel.send(.cancel)
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        let canSubmit = viewModel.state.error == nil
                        Button("Submit") {
                            if canSubmit {
                                viewModel.send(.submit(viewModel.person))
                                dismiss()
                            }
                        }.disabled(!canSubmit)
                    }
                }
            }
        }
    }
}

private extension HorizontalAlignment {
    struct TextFieldAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }

    static let textFieldAlignmentGuide = HorizontalAlignment(
        TextFieldAlignment.self
    )
}
