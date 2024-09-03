import SwiftUI

struct ContentView: View {
    @State private var showCountdown = false
    @State private var showGallery = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: TermsView(showCountdown: $showCountdown, showGallery: $showGallery)) {
                    Text("Przejdź do regulaminu")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                if showCountdown {
                    NavigationLink(destination: CountdownView()) {
                        Text("ODLICZANIE")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                if showGallery {
                    NavigationLink(destination: PhotoGalleryView()) {
                        Text("HISTORIA")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationBarTitle("Menu", displayMode: .inline)
        }
    }
}
