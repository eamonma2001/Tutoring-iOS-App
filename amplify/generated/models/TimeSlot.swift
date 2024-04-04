// swiftlint:disable all
import Amplify
import Foundation

public struct TimeSlot: Model {
  public let id: String
  public var start: Temporal.DateTime
  public var end: Temporal.DateTime
  public var userId: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      start: Temporal.DateTime,
      end: Temporal.DateTime,
      userId: String) {
    self.init(id: id,
      start: start,
      end: end,
      userId: userId,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      start: Temporal.DateTime,
      end: Temporal.DateTime,
      userId: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.start = start
      self.end = end
      self.userId = userId
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}