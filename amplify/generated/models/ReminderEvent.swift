// swiftlint:disable all
import Amplify
import Foundation

public struct ReminderEvent: Model {
  public let id: String
  public var title: String
  public var end_at: String
  public var context_name: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      title: String,
      end_at: String,
      context_name: String? = nil) {
    self.init(id: id,
      title: title,
      end_at: end_at,
      context_name: context_name,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      title: String,
      end_at: String,
      context_name: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.title = title
      self.end_at = end_at
      self.context_name = context_name
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}