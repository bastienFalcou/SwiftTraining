//  Created by Bastien Falcou on 4/9/23.

import SwiftUI

struct EditPersonView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = "" {
        didSet {
            
        }
    }

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
                        // TODO: The following is very ugly, I didn't find the better way of doing it in a reasonable amount of time
                        TextField("Language", text: viewModel.binding(\.name)).onChange(of: viewModel.state.name) { _ in
                            viewModel.name = viewModel.state.name
                        }
                    }
                    HStack {
                        Text("Language")
                            .bold()
                            .padding(.leading, 16)
                        Spacer()
                        // TODO: The following is very ugly, I didn't find the better way of doing it in a reasonable amount of time
                        TextField("Language", text: viewModel.binding(\.language)).onChange(of: viewModel.state.language) { _ in
                            viewModel.language = viewModel.state.language
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
