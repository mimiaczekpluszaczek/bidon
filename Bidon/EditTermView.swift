import SwiftUI

struct EditTermView: View {
    @Binding var term: Term
    @Binding var terms: [Term]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Edytuj treść warunku", text: $term.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button(action: {
                    deleteTerm()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Usuń")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button(action: {
                    saveTerm()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Zapisz")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    private func saveTerm() {
        if let index = terms.firstIndex(where: { $0.id == term.id }) {
            terms[index] = term
            saveTerms()
        }
    }

    private func deleteTerm() {
        if let index = terms.firstIndex(where: { $0.id == term.id }) {
            terms.remove(at: index)
            saveTerms()
        }
    }

    private func saveTerms() {
        if let encoded = try? JSONEncoder().encode(terms) {
            UserDefaults.standard.set(encoded, forKey: "terms")
        }
    }
}
