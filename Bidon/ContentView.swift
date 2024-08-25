import SwiftUI

struct Term: Identifiable {
    let id = UUID()
    var text: String
}

struct TermsView: View {
    @State private var terms: [Term] = [
        Term(text: "Warunek 1"),
        Term(text: "Warunek 2"),
        Term(text: "Warunek 3"),
        Term(text: "Warunek 4"),
        Term(text: "Warunek 5"),
        Term(text: "Warunek 6"),
        Term(text: "Warunek 7"),
        Term(text: "Warunek 8"),
        Term(text: "Warunek 9"),
        Term(text: "Warunek 10")
    ]
    @State private var selectedTerm: Term?
    @State private var isEditing = false
    
    @State private var olaAgreed = false
    @State private var michalAgreed = false
    @State private var showAgreementAlert = false
    @State private var selectedName: String?
    @State private var responseOla: String?
    @State private var responseMichal: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Regulamin")
                .font(.largeTitle)
                .padding(.bottom)

            List {
                ForEach(terms) { term in
                    HStack {
                        Text(term.text)
                        Spacer()
                        Button(action: {
                            selectedTerm = term
                            isEditing = true
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .frame(height: 300)

            Spacer()

            HStack {
                Button(action: {
                    selectedName = "Ola"
                    showAgreementAlert = true
                }) {
                    Text("Ola")
                        .padding()
                        .background(responseOla == "Tak" ? Color.pink : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAgreementAlert) {
                    Alert(
                        title: Text("Czy zgadzasz się na powyższe warunki?"),
                        primaryButton: .default(Text("Tak")) {
                            if selectedName == "Ola" {
                                responseOla = "Tak"
                            } else if selectedName == "Michał" {
                                responseMichal = "Tak"
                            }
                        },
                        secondaryButton: .destructive(Text("Nie")) {
                            if selectedName == "Ola" {
                                responseOla = "Nie"
                            } else if selectedName == "Michał" {
                                responseMichal = "Nie"
                            }
                        }
                    )
                }

                Button(action: {
                    selectedName = "Michał"
                    showAgreementAlert = true
                }) {
                    Text("Michał")
                        .padding()
                        .background(responseMichal == "Tak" ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Regulamin", displayMode: .inline)
        .sheet(isPresented: $isEditing) {
            if let selectedTerm = selectedTerm {
                EditTermView(term: $terms[terms.firstIndex(where: { $0.id == selectedTerm.id })!])
            }
        }
    }
}

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

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: TermsView()) {
                    Text("Przejdź do regulaminu")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationBarTitle("Menu", displayMode: .inline)
        }
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
