import SwiftUI

struct CelebrationView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }

                Spacer()

                Text("Gratulacje!")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                Text("Warunki zostały zaakceptowane!")
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                ConfettiView()

                Spacer()
            }
        }
    }
}
