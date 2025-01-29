import Foundation

public protocol Interactor<State, Action> {
    associatedtype State: Equatable & Sendable
    associatedtype Action: Sendable
    associatedtype Body

    @InteractorBuilder<State, Action>
    var body: Body { get }

    func transform(state: inout State, action: Action) -> InteractionResult<State>
}

extension Interactor where Body == Never {
  /// A non-existent body.
  ///
  /// > Warning: Do not invoke this property directly. It will trigger a fatal error at runtime.
  @_transparent
  public var body: Body {
    fatalError(
      """
      '\(Self.self)' has no body. …

      Do not access a reducer's 'body' property directly, as it may not exist. To run a reducer, \
      call 'Reducer.reduce(into:action:)', instead.
      """
    )
  }
}

extension Interactor where Body: Interactor<State, Action> {
    public func transform(state: inout State, action: Action) -> InteractionResult<State> {
        return self.body.transform(state: &state, action: action)
    }
}
