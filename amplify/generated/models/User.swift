// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model, Identifiable {
  public let id: String
  public var name: String
  public var primary_email: String
  public var avatar_url: String?
  public var courses: List<Course>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      primary_email: String,
      avatar_url: String? = nil,
      courses: List<Course>? = []) {
    self.init(id: id,
      name: name,
      primary_email: primary_email,
      avatar_url: avatar_url,
      courses: courses,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      primary_email: String,
      avatar_url: String? = nil,
      courses: List<Course>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.primary_email = primary_email
      self.avatar_url = avatar_url
      self.courses = courses
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
        primary_email = try container.decode(String.self, forKey: .primary_email)
        avatar_url = try container.decode(String.self, forKey: .avatar_url)
    }
    
}


