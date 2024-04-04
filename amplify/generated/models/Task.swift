// swiftlint:disable all
import Amplify
import Foundation

public struct Task: Model {
  public let id: String
  public var name: String
  public var description: String?
  public var isDone: Bool?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      description: String? = nil,
      isDone: Bool? = nil) {
    self.init(id: id,
      name: name,
      description: description,
      isDone: isDone,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      description: String? = nil,
      isDone: Bool? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.description = description
      self.isDone = isDone
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}