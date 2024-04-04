// swiftlint:disable all
import Amplify
import Foundation

extension CalendarEvent {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case start_at
    case end_at
    case location_name
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let calendarEvent = CalendarEvent.keys
    
    model.listPluralName = "CalendarEvents"
    model.syncPluralName = "CalendarEvents"
    
    model.attributes(
      .primaryKey(fields: [calendarEvent.id])
    )
    
    model.fields(
      .field(calendarEvent.id, is: .required, ofType: .string),
      .field(calendarEvent.title, is: .required, ofType: .string),
      .field(calendarEvent.start_at, is: .required, ofType: .string),
      .field(calendarEvent.end_at, is: .required, ofType: .string),
      .field(calendarEvent.location_name, is: .optional, ofType: .string),
      .field(calendarEvent.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(calendarEvent.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension CalendarEvent: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}