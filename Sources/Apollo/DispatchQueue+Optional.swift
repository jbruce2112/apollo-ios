import Foundation
import ApolloCore

extension DispatchQueue: ApolloCompatible {}

public extension ApolloExtension where Base == DispatchQueue {

  static func performAsyncIfNeeded(on callbackQueue: DispatchQueue?, action: @escaping () -> Void) {
    if let callbackQueue = callbackQueue {
      // A callback queue was provided, perform the action on that queue
      callbackQueue.async {
        action()
      }
    } else {
      // Perform the action on the current queue
      action()
    }
  }

  static func returnResultAsyncIfNeeded<T>(on callbackQueue: DispatchQueue?,
                                           action: ((Result<T, Error>) -> Void)?,
                                           result: Result<T, Error>) {
    guard let action = action else {
      return
    }

    self.performAsyncIfNeeded(on: callbackQueue) {
      action(result)
    }
  }
}
