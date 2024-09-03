import SwiftUI

struct EditTermView: View {
    @Binding var term: Term
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Treść warunku", text: $term.text)
            }
            .navigationBarTitle("Edytuj Warunek", displayMode: .inline)
            .navigationBarItems(trailing: Button("Zapisz") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
