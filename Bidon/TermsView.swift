import SwiftUI

struct Term: Identifiable, Codable {
    var id = UUID()
    var text: String
}


struct TermsView: View {
    @Binding var hasAcceptedTerms: Bool
    @Binding var acceptedByOla: Bool
    @Binding var acceptedByMichal: Bool
    
    @State private var terms: [Term] = []
    @State private var showConfirmationAlert = false
    @State private var showCelebration = false
    @State private var currentUser = ""
    @State private var selectedTerm: Term?

    var body: some View {
        VStack {
            Text("Regulamin")
                .font(.largeTitle)
                .padding()

            // Ikonka plusa nad listą warunków
            HStack {
                Spacer()
                Button(action: {
                    addNewTerm()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 20)
            }
            .padding(.bottom, 10)

            List {
                ForEach(terms) { term in
                    Button(action: {
                        selectedTerm = term
                    }) {
                        HStack {
                            Text(term.text)
                            Spacer()
                            Image(systemName: "pencil")
                        }
                    }
                }
                .onDelete(perform: deleteTerm)
            }

            HStack {
                Button(action: {
                    currentUser = "Ola"
                    showConfirmationAlert = true
                }) {
                    Text("Ola")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(acceptedByOla ? Color.pink : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    currentUser = "Michal"
                    showConfirmationAlert = true
                }) {
                    Text("Michał")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(acceptedByMichal ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .alert(isPresented: $showConfirmationAlert) {
                let isAccepting = (currentUser == "Ola" && !acceptedByOla) || (currentUser == "Michal" && !acceptedByMichal)
                
                return Alert(
                    title: Text("Potwierdzenie"),
                    message: Text(isAccepting ? "Czy na pewno chcesz zaakceptować warunki?" : "Czy na pewno chcesz cofnąć zgodę?"),
                    primaryButton: .default(Text(isAccepting ? "Tak" : "Nie")) {
                        if currentUser == "Ola" {
                            acceptedByOla.toggle()
                        } else if currentUser == "Michal" {
                            acceptedByMichal.toggle()
                        }
                        updateAcceptance()
                    },
                    secondaryButton: .cancel(Text("Anuluj"))
                )
            }
        }
        .padding()
        .onAppear {
            loadTerms()
            UserDefaults.standard.set(acceptedByOla, forKey: "acceptedByOla")
            UserDefaults.standard.set(acceptedByMichal, forKey: "acceptedByMichal")
        }
        .fullScreenCover(item: $selectedTerm) { term in
            if let index = terms.firstIndex(where: { $0.id == term.id }) {
                EditTermView(term: $terms[index], terms: $terms)
            }
        }
        .fullScreenCover(isPresented: $showCelebration) {
            CelebrationView()
        }
    }

    // Funkcja dodająca nowy warunek
    private func addNewTerm() {
        let newTerm = Term(text: "")
        terms.append(newTerm)
        selectedTerm = newTerm
        saveTerms()
    }

    // Funkcja usuwająca warunek
    private func deleteTerm(at offsets: IndexSet) {
        terms.remove(atOffsets: offsets)
        saveTerms()
    }

    // Funkcja zapisująca warunki do UserDefaults
    private func saveTerms() {
        if let encoded = try? JSONEncoder().encode(terms) {
            UserDefaults.standard.set(encoded, forKey: "terms")
        }
    }

    // Funkcja ładująca warunki z UserDefaults
    private func loadTerms() {
        if let savedTerms = UserDefaults.standard.data(forKey: "terms"),
           let decodedTerms = try? JSONDecoder().decode([Term].self, from: savedTerms) {
            terms = decodedTerms
        }
    }

    private func updateAcceptance() {
        UserDefaults.standard.set(acceptedByOla, forKey: "acceptedByOla")
        UserDefaults.standard.set(acceptedByMichal, forKey: "acceptedByMichal")
        
        // Sprawdź, czy obie osoby wyraziły zgodę
        hasAcceptedTerms = acceptedByOla && acceptedByMichal
        UserDefaults.standard.set(hasAcceptedTerms, forKey: "hasAcceptedTerms")
        
        // Wyświetl CelebrationView, jeśli warunki są zaakceptowane przez obie osoby
        if hasAcceptedTerms {
            showCelebration = true
        }
    }
}
