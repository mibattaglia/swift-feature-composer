import Foundation

/// A reusable abstraction for state-action transformation
public struct Interact<State: Equatable, Action>: Interactor {
    let handler: (inout State, Action) -> InteractionResult<State>

    public init(handler: @escaping (inout State, Action) -> InteractionResult<State>) {
        self.handler = handler
    }

    public var body: some Interactor<State, Action> {
        self
    }

    public func transform(state: inout State, action: Action) -> InteractionResult<State> {
        handler(&state, action)
    }
}
