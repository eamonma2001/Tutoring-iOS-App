// swiftlint:disable all
import Amplify
import Foundation

extension MeetingRequest {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case student
    case ta
    case date
    case createdAt
    case updatedAt
    case meetingRequestStudentId
    case meetingRequestTaId
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let meetingRequest = MeetingRequest.keys
    
    model.listPluralName = "MeetingRequests"
    model.syncPluralName = "MeetingRequests"
    
    model.attributes(
      .primaryKey(fields: [meetingRequest.id])
    )
    
    model.fields(
      .field(meetingRequest.id, is: .required, ofType: .string),
      .hasOne(meetingRequest.student, is: .required, ofType: User.self, associatedWith: User.keys.id, targetNames: ["meetingRequestStudentId"]),
      .hasOne(meetingRequest.ta, is: .required, ofType: User.self, associatedWith: User.keys.id, targetNames: ["meetingRequestTaId"]),
      .field(meetingRequest.date, is: .required, ofType: .dateTime),
      .field(meetingRequest.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(meetingRequest.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(meetingRequest.meetingRequestStudentId, is: .required, ofType: .string),
      .field(meetingRequest.meetingRequestTaId, is: .required, ofType: .string)
    )
    }
}

extension MeetingRequest: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}