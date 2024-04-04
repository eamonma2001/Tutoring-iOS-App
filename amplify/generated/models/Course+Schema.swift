// swiftlint:disable all
import Amplify
import Foundation

extension Course {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case user
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let course = Course.keys
    
    model.listPluralName = "Courses"
    model.syncPluralName = "Courses"
    
    model.attributes(
      .index(fields: ["userId"], name: "byUser"),
      .primaryKey(fields: [course.id])
    )
    
    model.fields(
      .field(course.id, is: .required, ofType: .string),
      .field(course.name, is: .required, ofType: .string),
      .belongsTo(course.user, is: .optional, ofType: User.self, targetNames: ["userId"]),
      .field(course.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(course.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Course: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}