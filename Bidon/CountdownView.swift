import SwiftUI

struct CountdownView: View {
    @State private var now = Date()
    private let eventDate = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 8))!

    var body: some View {
        ZStack {
            // Ciemne tło takie jak w menu
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("Odliczanie do tajemniczego wydarzenia")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white) // Tekst w białym kolorze dla kontrastu z ciemnym tłem
                    .multilineTextAlignment(.center)
                    .padding()

                // Licznik z zaokrąglonym tłem
                Text(timeRemaining)
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.3)) // Szare, półprzezroczyste tło licznika
                    .cornerRadius(15)
                    .shadow(radius: 10)

                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear(perform: startTimer)
    }

    private var timeRemaining: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: now, to: eventDate) ?? "Czas upłynął!"
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.now = Date()
        }
    }
}
