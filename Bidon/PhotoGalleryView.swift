import SwiftUI
import PhotosUI

struct PhotoGalleryView: View {
    @State private var selectedPhotos: [UIImage] = []

    var body: some View {
        VStack {
            if selectedPhotos.isEmpty {
                Text("Brak wybranych zdjęć")
                    .font(.title2)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(selectedPhotos, id: \.self) { photo in
                            Image(uiImage: photo)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
            }

            Button(action: selectPhotos) {
                Text("Zarządzaj zdjęciami")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .navigationBarTitle("Galeria zdjęć", displayMode: .inline)
    }

    func selectPhotos() {
        // Zaimplementuj wybieranie zdjęć z galerii urządzenia
        // To wymaga użycia PHPickerViewController lub UIImagePickerController, 
        // zależnie od wymagań projektu i preferencji.
    }
}
