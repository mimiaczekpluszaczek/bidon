import SwiftUI

struct ContentView: View {
    @State private var hasAcceptedTerms: Bool
    @State private var acceptedByOla: Bool
    @State private var acceptedByMichal: Bool
    
    init() {
        _hasAcceptedTerms = State(initialValue: UserDefaults.standard.bool(forKey: "hasAcceptedTerms"))
        _acceptedByOla = State(initialValue: UserDefaults.standard.bool(forKey: "acceptedByOla"))
        _acceptedByMichal = State(initialValue: UserDefaults.standard.bool(forKey: "acceptedByMichal"))
    }

    var body: some View {
        NavigationView {
            VStack {
                if hasAcceptedTerms {
                    Text("Moduły dostępne po akceptacji regulaminu:")
                        .font(.title2)
                        .padding()

                    // Moduł Odliczanie
                    NavigationLink(destination: CountdownView()) {
                        Text("Odliczanie")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    // Moduł Historia
                    NavigationLink(destination: HistoryView()) {
                        Text("Historia")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                } else {
                    Text("Musisz zaakceptować regulamin, aby uzyskać dostęp do modułów.")
                        .font(.headline)
                        .padding()
                }

                // Przycisk przejścia do regulaminu
                NavigationLink(destination: TermsView(hasAcceptedTerms: $hasAcceptedTerms, acceptedByOla: $acceptedByOla, acceptedByMichal: $acceptedByMichal)) {
                    Text("Przejdź do regulaminu")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Główne menu")
        }
        .onAppear {
            // Aktualizacja stanu przy załadowaniu widoku
            hasAcceptedTerms = UserDefaults.standard.bool(forKey: "hasAcceptedTerms")
            acceptedByOla = UserDefaults.standard.bool(forKey: "acceptedByOla")
            acceptedByMichal = UserDefaults.standard.bool(forKey: "acceptedByMichal")
        }
    }
}
