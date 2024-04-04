// swiftlint:disable all
import Amplify
import Foundation

public struct CalendarEvent: Model {
  public let id: String
  public var title: String
  public var start_at: String
  public var end_at: String
  public var location_name: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      title: String,
      start_at: String,
      end_at: String,
      location_name: String? = "Default Location") {
    self.init(id: id,
      title: title,
      start_at: start_at,
      end_at: end_at,
      location_name: location_name,
      createdAt: nil,
      updatedAt: nil)
  }
    
  internal init(id: String = UUID().uuidString,
      title: String,
      start_at: String,
      end_at: String,
      location_name: String? = "Default Location",
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.title = title
      self.start_at = start_at
      self.end_at = end_at
      self.location_name = location_name
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
        title = try container.decode(String.self, forKey: .title)
        start_at = try container.decode(String.self, forKey: .start_at)
        end_at = try container.decode(String.self, forKey: .end_at)  
        if let lo = try? container.decode(String.self, forKey: .location_name) {
            location_name = lo
        } else {
            location_name = "Default Location"
        }
    }
}


