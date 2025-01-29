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
  public var body: Body {
    fatalError(
      """
      '\(Self.self)' has no body.
      """
    )
  }
}

extension Interactor where Body: Interactor<State, Action> {
    public func transform(state: inout State, action: Action) -> InteractionResult<State> {
        return self.body.transform(state: &state, action: action)
    }
}
