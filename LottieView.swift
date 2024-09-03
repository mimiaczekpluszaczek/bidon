import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String

    func makeUIView(context: Context) -> some UIView {
        let animationView = AnimationView(name: filename)
        animationView.loopMode = .loop // Poprawna składnia dla ustawienia pętli
        animationView.play()
        return animationView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
