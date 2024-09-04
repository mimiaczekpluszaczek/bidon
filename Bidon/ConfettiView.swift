import SwiftUI

struct ConfettiShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: rect) // Definiuje kształt jako elipsę (okrąg)
        return path
    }
}

struct ConfettiView: View {
    @State private var startAnimation = false

    var body: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { i in
                ConfettiShape()
                    .foregroundColor(self.randomColor())
                    .frame(width: 10, height: 10)
                    .position(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                              y: self.startAnimation ? UIScreen.main.bounds.height : -100)
                    .animation(
                        .linear(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: false),
                        value: startAnimation
                    )
            }
        }
        .onAppear {
            self.startAnimation = true
        }
    }

    func randomColor() -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
        return colors.randomElement() ?? .black
    }
}
