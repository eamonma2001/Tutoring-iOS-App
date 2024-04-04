// swiftlint:disable all
import Amplify
import Foundation

public struct Course: Model {
  public let id: String
  public var name: String
  public var user: User?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
    
  public init(id: String = UUID().uuidString,
      name: String,
      user: User? = nil) {
    self.init(id: id,
      name: name,
      user: user,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      user: User? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.user = user
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode 'id' as a string, converting from an integer if necessary
        if let idInt = try? container.decode(Int.self, forKey: .id) {
            id = String(idInt)
        } else {
            id = try container.decode(String.self, forKey: .id)
        }

        // Decode other fields normally
        name = try container.decode(String.self, forKey: .name)
    }
}


