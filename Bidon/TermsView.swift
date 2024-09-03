import SwiftUI

import Foundation

struct Term: Identifiable, Codable {
    let id: UUID
    var text: String

    init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
    }
}
// Rozszerzenie UserDefaults do przechowywania i ładowania Termów
extension UserDefaults {
    
    private enum Keys {
        static let termsKey = "terms"
    }
    
    func saveTerms(_ terms: [Term]) {
        if let encoded = try? JSONEncoder().encode(terms) {
            set(encoded, forKey: Keys.termsKey)
        }
    }
    
    func loadTerms() -> [Term]? {
        if let savedTerms = data(forKey: Keys.termsKey) {
            if let decodedTerms = try? JSONDecoder().decode([Term].self, from: savedTerms) {
                return decodedTerms
            }
        }
        return nil
    }
}
struct TermsView: View {
    @State private var terms: [Term] = UserDefaults.standard.loadTerms() ?? [
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
    @State private var showCelebration = false
    @State private var selectedName: String?
    @State private var responseOla: String?
    @State private var responseMichal: String?
    
    @Binding var showCountdown: Bool
    @Binding var showGallery: Bool

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
                                olaAgreed = true
                            } else if selectedName == "Michał" {
                                responseMichal = "Tak"
                                michalAgreed = true
                            }
                            checkAgreements()
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
        .sheet(isPresented: $isEditing, onDismiss: saveTerms) {
            if let selectedTerm = selectedTerm {
                EditTermView(term: $terms[terms.firstIndex(where: { $0.id == selectedTerm.id })!])
            }
        }
        .fullScreenCover(isPresented: $showCelebration, content: {
            CelebrationView()
        })
    }

    func checkAgreements() {
        if olaAgreed && michalAgreed {
            showCelebration = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                showCountdown = true
                showGallery = true
                showCelebration = false
            }
        }
    }

    func saveTerms() {
        UserDefaults.standard.saveTerms(terms)
    }
}
