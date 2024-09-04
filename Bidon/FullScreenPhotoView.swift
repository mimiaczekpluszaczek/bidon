import SwiftUI

struct IdentifiableImage: Identifiable {
    var id = UUID()
    var image: UIImage
}

struct FullScreenPhotoView: View {
    var image: UIImage
    @Environment(\.presentationMode) var presentationMode
    @State private var dragOffset = CGSize.zero // Przechowuje przesunięcie gestu

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Spacer()

                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: dragOffset.height) // Przesunięcie obrazu podczas przeciągania
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Śledzenie przesunięcia
                                if value.translation.height > 0 {
                                    dragOffset = value.translation
                                }
                            }
                            .onEnded { value in
                                // Zamykanie widoku, jeśli przesunięcie jest duże
                                if dragOffset.height > 150 {
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    dragOffset = .zero // Resetowanie przesunięcia, jeśli gest nie spełnia warunków
                                }
                            }
                    )

                Spacer()
            }
        }
    }
}
