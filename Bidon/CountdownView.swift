import SwiftUI

struct CountdownView: View {
    @State private var now = Date()
    private let newYear = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!

    var body: some View {
        VStack {
            Text("Odliczanie do Sylwestra")
                .font(.largeTitle)
                .padding()

            Text(timeRemaining)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .padding()

            Spacer()
        }
        .onAppear(perform: startTimer)
    }

    private var timeRemaining: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: now, to: newYear) ?? "Czas upłynął!"
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.now = Date()
        }
    }
}
