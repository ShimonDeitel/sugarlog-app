import Foundation

struct ReadingEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var title: String
    var metric: Int          // mg/dL
    var tag: String          // Meal context
    var note: String = ""
}

enum BloodSugarNoteTags {
    static let all: [String] = ["Fasting", "Before meal", "After meal", "Bedtime"]
}
