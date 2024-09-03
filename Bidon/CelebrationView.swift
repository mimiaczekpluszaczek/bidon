import SwiftUI

struct CelebrationView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Gratulacje!")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                Text("Warunki zostały zaakceptowane!")
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                LottieView(filename: "confetti")
                    .frame(width: 200, height: 200)
                
                Spacer()
            }
        }
    }
}
