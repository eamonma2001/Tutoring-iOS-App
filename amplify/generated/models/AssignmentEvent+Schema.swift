// swiftlint:disable all
import Amplify
import Foundation

extension AssignmentEvent {
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
    let assignmentEvent = AssignmentEvent.keys
    
    model.listPluralName = "AssignmentEvents"
    model.syncPluralName = "AssignmentEvents"
    
    model.attributes(
      .primaryKey(fields: [assignmentEvent.id])
    )
    
    model.fields(
      .field(assignmentEvent.id, is: .required, ofType: .string),
      .field(assignmentEvent.title, is: .required, ofType: .string),
      .field(assignmentEvent.end_at, is: .required, ofType: .string),
      .field(assignmentEvent.context_name, is: .optional, ofType: .string),
      .field(assignmentEvent.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(assignmentEvent.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension AssignmentEvent: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}