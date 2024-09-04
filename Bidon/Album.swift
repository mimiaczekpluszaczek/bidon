import SwiftUI

struct Album: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var date: Date
    var photoData: [Data] = [] // Zamiast UIImage, przechowujemy dane
}
