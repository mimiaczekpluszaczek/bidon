import SwiftUI
import PhotosUI

struct EditAlbumView: View {
    @Binding var album: Album
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPhotos: [PhotosPickerItem] = []

    var onDelete: (() -> Void)? // Callback do usuwania albumu

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
                                album.photoData.append(data) // Dodajemy zdjęcia do albumu
                            }
                        case .failure(let error):
                            print("Błąd ładowania zdjęcia: \(error.localizedDescription)")
                        }
                    }
                }
            }

            // Wyświetlenie dodanych zdjęć
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
                                        album.photoData.remove(at: index) // Usunięcie zdjęcia z albumu
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

            // Przycisk zapisywania zmian
            Button(action: {
                presentationMode.wrappedValue.dismiss() // Zapisz zmiany i zamknij edycję
            }) {
                Text("Zapisz album")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // Przycisk usuwania albumu
            if let onDelete = onDelete {
                Button(action: {
                    onDelete() // Wywołujemy callback do usunięcia albumu
                    presentationMode.wrappedValue.dismiss() // Zamykanie widoku po usunięciu
                }) {
                    Text("Usuń album")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }

            Spacer()
        }
        .padding()
    }
}
