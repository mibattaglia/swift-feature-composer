import Foundation

/// A reusable abstraction for state-action transformation
public struct Interact<State: Equatable & Sendable, Action: Sendable>: Interactor {
    let handler: @Sendable (inout State, Action) -> InteractionResult<State>

    public init(handler: @escaping @Sendable (inout State, Action) -> InteractionResult<State>) {
        self.handler = handler
    }

    public var body: some Interactor<State, Action> {
        self
    }

    public func transform(state: inout State, action: Action) -> InteractionResult<State> {
        handler(&state, action)
    }
}
