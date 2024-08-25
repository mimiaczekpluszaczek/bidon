//
//  ContentView.swift
//  Bidon
//
//  Created by Michal on 25/08/2024.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Menu Główne")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: Text("Galeria zdjęć").font(.largeTitle)) {
                    Text("Galeria zdjęć")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                }
                
                NavigationLink(destination: TermsView()) {
                    Text("Przejdź do regulaminu")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationBarTitle("Moja Aplikacja", displayMode: .inline)
        }
    }
}

struct TermsView: View {
    @State private var olaAgreed = false
    @State private var michalAgreed = false
    @State private var showAlert = false
    @State private var selectedName = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Regulamin")
                .font(.largeTitle)
                .padding(.bottom)

            List {
                ForEach(1..<11) { index in
                    Text("Warunek \(index)")
                }
            }
            .frame(height: 300)

            Spacer()

            HStack {
                Button(action: {
                    selectedName = "Ola"
                    showAlert = true
                }) {
                    Text("Ola")
                        .padding()
                        .background(olaAgreed ? Color.pink : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Czy zgadzasz się na powyższe warunki?"),
                        primaryButton: .default(Text("Tak")) {
                            if selectedName == "Ola" {
                                olaAgreed = true
                            } else if selectedName == "Michał" {
                                michalAgreed = true
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }

                Button(action: {
                    selectedName = "Michał"
                    showAlert = true
                }) {
                    Text("Michał")
                        .padding()
                        .background(michalAgreed ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Regulamin", displayMode: .inline)
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



#Preview {
    ContentView()
}
