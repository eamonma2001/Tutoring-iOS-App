// swiftlint:disable all
import Amplify
import Foundation

extension Task {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case description
    case isDone
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let task = Task.keys
    
    model.listPluralName = "Tasks"
    model.syncPluralName = "Tasks"
    
    model.attributes(
      .primaryKey(fields: [task.id])
    )
    
    model.fields(
      .field(task.id, is: .required, ofType: .string),
      .field(task.name, is: .required, ofType: .string),
      .field(task.description, is: .optional, ofType: .string),
      .field(task.isDone, is: .optional, ofType: .bool),
      .field(task.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(task.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Task: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}