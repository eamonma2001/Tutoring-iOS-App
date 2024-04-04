// swiftlint:disable all
import Amplify
import Foundation

public struct MeetingRequest: Model {
  public let id: String
  public var student: User?
  public var ta: User?
  public var date: Temporal.DateTime
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  public var meetingRequestStudentId: String
  public var meetingRequestTaId: String
  
  public init(id: String = UUID().uuidString,
      student: User,
      ta: User,
      date: Temporal.DateTime,
      meetingRequestStudentId: String,
      meetingRequestTaId: String) {
    self.init(id: id,
      student: student,
      ta: ta,
      date: date,
      createdAt: nil,
      updatedAt: nil,
      meetingRequestStudentId: meetingRequestStudentId,
      meetingRequestTaId: meetingRequestTaId)
  }
  internal init(id: String = UUID().uuidString,
      student: User,
      ta: User,
      date: Temporal.DateTime,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil,
      meetingRequestStudentId: String,
      meetingRequestTaId: String) {
      self.id = id
      self.student = student
      self.ta = ta
      self.date = date
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self.meetingRequestStudentId = meetingRequestStudentId
      self.meetingRequestTaId = meetingRequestTaId
  }
}
