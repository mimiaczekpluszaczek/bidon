import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String

    func makeUIView(context: Context) -> some UIView {
        let view = AnimationView(name: filename)
        view.loopMode = .loop
        view.play()
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
