import Foundation

extension Encodable {
    public func encode() -> String {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)!
        } catch {
            return ""
        }
    }
}
