import SwiftUI
import PhotosUI

struct EditAlbumView: View {
    @Binding var album: Album
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPhotos: [PhotosPickerItem] = []

    var body: some View {
        VStack {
            TextField("Nazwa albumu", text: $album.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Opis albumu", text: $album.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Data albumu", selection: $album.date, displayedComponents: .date)
                .padding()

            // Sekcja dodawania zdjęć
            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 10, matching: .images) {
                Text("Dodaj nowe zdjęcia")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: selectedPhotos) { newItems in
                for item in newItems {
                    item.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data {
                                album.photoData.append(data) // Dodawanie zdjęć
                            }
                        case .failure(let error):
                            print("Błąd ładowania zdjęcia: \(error.localizedDescription)")
                        }
                    }
                }
            }

            // Lista zdjęć z możliwością usunięcia
            if !album.photoData.isEmpty {
                Text("Zdjęcia w albumie")
                    .font(.headline)
                    .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(album.photoData.enumerated()), id: \.element) { index, data in
                            if let image = UIImage(data: data) {
                                VStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)

                                    Button(action: {
                                        album.photoData.remove(at: index) // Usunięcie zdjęcia
                                    }) {
                                        Text("Usuń")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }

            // Przycisk zapisania albumu
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Zapisz album")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // Przycisk usunięcia albumu
            Button(action: {
                deleteAlbum()
            }) {
                Text("Usuń album")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    // Funkcja usuwania albumu
    func deleteAlbum() {
        if let index = UserDefaults.standard.array(forKey: "albums")?.firstIndex(where: { ($0 as! Album).id == album.id }) {
            var albums = UserDefaults.standard.array(forKey: "albums") as! [Album]
            albums.remove(at: index)
            UserDefaults.standard.set(albums, forKey: "albums")
        }
        presentationMode.wrappedValue.dismiss()
    }
}
