// swiftlint:disable all
import Amplify
import Foundation

extension TimeSlot {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case start
    case end
    case userId
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let timeSlot = TimeSlot.keys
    
    model.listPluralName = "TimeSlots"
    model.syncPluralName = "TimeSlots"
    
    model.attributes(
      .primaryKey(fields: [timeSlot.id])
    )
    
    model.fields(
      .field(timeSlot.id, is: .required, ofType: .string),
      .field(timeSlot.start, is: .required, ofType: .dateTime),
      .field(timeSlot.end, is: .required, ofType: .dateTime),
      .field(timeSlot.userId, is: .required, ofType: .string),
      .field(timeSlot.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(timeSlot.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension TimeSlot: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}