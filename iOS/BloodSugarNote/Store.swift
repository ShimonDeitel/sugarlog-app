import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [ReadingEntry] = []
    @Published var isPro: Bool = false

    // Free-tier cap. Kept comfortably above seed-data count so a fresh
    // install never trips the paywall immediately.
    static let freeLimit = 40

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("sugarlog_entries.json")
        load()
    }

    func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([ReadingEntry].self, from: data) {
            entries = decoded
        } else {
            entries = [
            ReadingEntry(date: Date().addingTimeInterval(-0), title: "Morning reading", metric: 98, tag: "Fasting"),
            ReadingEntry(date: Date().addingTimeInterval(-86400), title: "After breakfast", metric: 132, tag: "After meal")
            ]
            save()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    @discardableResult
    func add(title: String, metric: Int, tag: String, note: String = "") -> Bool {
        guard canAddMore else { return false }
        entries.insert(ReadingEntry(title: title, metric: metric, tag: tag, note: note), at: 0)
        save()
        Haptics.success()
        return true
    }

    func update(_ entry: ReadingEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: ReadingEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }
}
