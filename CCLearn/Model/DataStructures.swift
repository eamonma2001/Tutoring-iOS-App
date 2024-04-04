import Amplify

extension TimeSlot: Equatable, Hashable {
    public static func == (lhs: TimeSlot, rhs: TimeSlot) -> Bool {
        return lhs.start.iso8601String == rhs.start.iso8601String &&
        lhs.end.iso8601String == rhs.end.iso8601String && rhs.userId == lhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(start.iso8601String)
        hasher.combine(end.iso8601String)
    }
}
