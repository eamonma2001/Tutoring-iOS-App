// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "394758774dc590eb91691bbdd055932d"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: Course.self)
    ModelRegistry.register(modelType: ReminderEvent.self)
    ModelRegistry.register(modelType: CalendarEvent.self)
    ModelRegistry.register(modelType: AssignmentEvent.self)
    ModelRegistry.register(modelType: Task.self)
    ModelRegistry.register(modelType: TimeSlot.self)
    ModelRegistry.register(modelType: MeetingRequest.self)
  }
}