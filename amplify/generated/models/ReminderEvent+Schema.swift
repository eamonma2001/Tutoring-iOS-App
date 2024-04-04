// swiftlint:disable all
import Amplify
import Foundation

extension ReminderEvent {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case end_at
    case context_name
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let reminderEvent = ReminderEvent.keys
    
    model.listPluralName = "ReminderEvents"
    model.syncPluralName = "ReminderEvents"
    
    model.attributes(
      .primaryKey(fields: [reminderEvent.id])
    )
    
    model.fields(
      .field(reminderEvent.id, is: .required, ofType: .string),
      .field(reminderEvent.title, is: .required, ofType: .string),
      .field(reminderEvent.end_at, is: .required, ofType: .string),
      .field(reminderEvent.context_name, is: .optional, ofType: .string),
      .field(reminderEvent.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(reminderEvent.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension ReminderEvent: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}