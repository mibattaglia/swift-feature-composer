import Foundation

public protocol Interactor<State, Action> {
    associatedtype State: Equatable
    associatedtype Action
    associatedtype Body: Interactor

    @InteractorBuilder<State, Action>
    var body: Body { get }

    func transform(state: inout State, action: Action) -> InteractionResult<State>
}

extension Interactor where Body.State == Never {
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

extension Interactor {
    public func forwardActions<Target: Interactor>(
        to target: Target
    ) -> some Interactor where Target.State == State, Target.Action == Action {
        Interact { state, action in
            let first = self.transform(state: &state, action: action)
            let second = target.transform(state: &state, action: action)

            return first.merge(with: second)
        }
    }
}

extension Interactor {
    /// Takes a given action and transforms it into another action. This is useful when composing Interactors
    /// together inside of an `Interact` block
    /// - Parameter transform: a closure that transforms actions to the new type
    /// - Returns: An interactor that runs `transform` with the newly mapped action
    public func mapActions<NewAction>(
        _ transform: @escaping (NewAction) -> Action?
    ) -> some Interactor<State, NewAction> {
        Interact { state, newAction in
            guard let mappedAction = transform(newAction) else {
                return .state // No transformation, return no-op result
            }
            return self.transform(state: &state, action: mappedAction)
        }
    }
}
