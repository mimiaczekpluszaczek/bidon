import SwiftUI

struct HistoryView: View {
    @State private var albums: [Album] = []
    @State private var newAlbum = Album(name: "", description: "", date: Date())
    @State private var showEditAlbumView = false
    @State private var selectedAlbum: Album? // Album wybrany do edycji
    @State private var selectedImage: IdentifiableImage? // Zdjęcie wybrane do podglądu na pełnym ekranie

    var body: some View {
        NavigationView {
            VStack {
                if albums.isEmpty {
                    Text("Brak albumów")
                        .font(.title2)
                        .padding()
                } else {
                    ScrollViewReader { scrollViewProxy in
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(sortedAlbums()) { album in
                                    VStack(alignment: .leading) {
                                        ZStack {
                                            // Tło, które pokrywa zarówno tekst jak i fotografie
                                            Color.gray.opacity(0.2)
                                                .cornerRadius(10)
                                                .shadow(radius: 5)

                                            VStack(alignment: .leading) {
                                                // Klikalny tylko tekst albumu (nazwa, opis, data)
                                                VStack(alignment: .leading, spacing: 5) {
                                                    Button(action: {
                                                        selectedAlbum = album // Przejście do edycji albumu
                                                    }) {
                                                        VStack(alignment: .leading, spacing: 5) {
                                                            Text(album.name)
                                                                .font(.headline)
                                                            Text(album.description)
                                                                .font(.subheadline)
                                                            Text("Data: \(formattedDate(album.date))")
                                                                .font(.caption)
                                                        }
                                                    }
                                                    .padding(.bottom, 10) // Odstęp pod tekstem
                                                }

                                                // Galeria zdjęć w albumie
                                                ScrollView(.horizontal, showsIndicators: false) {
                                                    HStack {
                                                        ForEach(album.photoData, id: \.self) { data in
                                                            if let image = UIImage(data: data) {
                                                                Button(action: {
                                                                    selectedImage = IdentifiableImage(image: image) // Otwieramy zdjęcie na pełnym ekranie
                                                                }) {
                                                                    Image(uiImage: image)
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .frame(width: 100, height: 100)
                                                                        .cornerRadius(8)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .padding() // Odstęp wewnątrz ramki albumu
                                        }
                                        .padding(.horizontal) // Odstęp zewnętrzny
                                    }
                                    .id(album.id)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                        .onAppear {
                            if let lastAlbum = albums.last {
                                scrollViewProxy.scrollTo(lastAlbum.id, anchor: .bottom)
                            }
                        }
                    }
                }

                Button(action: {
                    showEditAlbumView = true
                }) {
                    Text("Stwórz nowy album")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationBarTitle("Historia", displayMode: .inline)
            .sheet(item: $selectedAlbum) { album in
                EditAlbumView(album: binding(for: album))
            }
            .sheet(isPresented: $showEditAlbumView) {
                EditAlbumView(album: $newAlbum)
                    .onDisappear {
                        if !newAlbum.name.isEmpty {
                            albums.append(newAlbum)
                            newAlbum = Album(name: "", description: "", date: Date())
                            saveAlbums()
                        }
                    }
            }
            // Wyświetlanie zdjęcia na pełnym ekranie z użyciem IdentifiableImage
            .fullScreenCover(item: $selectedImage) { identifiableImage in
                FullScreenPhotoView(image: identifiableImage.image)
            }
        }
        .onAppear {
            loadAlbums()
        }
    }

    // Funkcja sortująca albumy od najstarszych do najnowszych
    private func sortedAlbums() -> [Album] {
        return albums.sorted { $0.date < $1.date }
    }

    // Funkcja formatowania daty
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // Funkcja zapisująca albumy
    private func saveAlbums() {
        if let encoded = try? JSONEncoder().encode(albums) {
            UserDefaults.standard.set(encoded, forKey: "albums")
        }
    }

    // Funkcja ładująca albumy i sortująca je
    private func loadAlbums() {
        if let savedAlbums = UserDefaults.standard.data(forKey: "albums"),
           let decodedAlbums = try? JSONDecoder().decode([Album].self, from: savedAlbums) {
            albums = decodedAlbums.sorted { $0.date < $1.date }
        }
    }

    // Binding do wybranego albumu
    private func binding(for album: Album) -> Binding<Album> {
        guard let index = albums.firstIndex(where: { $0.id == album.id }) else {
            fatalError("Album not found")
        }
        return $albums[index]
    }
}
