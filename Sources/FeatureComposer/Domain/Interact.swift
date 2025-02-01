import Foundation

/// A reusable abstraction for state-action transformation
public struct Interact<State: Equatable, Action>: Interactor {
    private let handler: (inout State, Action) -> InteractionResult<State>

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

public struct PrependInteractor<State: Equatable, Action>: Interactor {
    enum PrefixState: Equatable {
        case pending
        case emitted
    }
    
    private final class Inner {
        var prefixState: PrefixState = .pending
    }
    
    private let lock = NSLock()
    private var inner = Inner()
    
    private let prependedActions: [Action]
    private let handler: (inout State, Action) -> InteractionResult<State>
    
    public init(
        prependedActions: [Action],
        handler: @escaping (inout State, Action) -> InteractionResult<State>
    ) {
        print(">> created")
        self.prependedActions = prependedActions
        self.handler = handler
    }
    
    public var body: some Interactor<State, Action> {
        self
    }
    
    public func transform(state: inout State, action: Action) -> InteractionResult<State> {
        defer { lock.unlock() }
        lock.lock()
        
        switch inner.prefixState {
        case .pending:
            let prefixResult = prependedActions.map { action in
                handler(&state, action)
            }
            let suffixAction = handler(&state, action)
            inner.prefixState = .emitted
            return suffixAction
                .merge(prefixResult)
        case .emitted:
            break
        }
        
        let suffixAction = handler(&state, action)
        return suffixAction
    }
}
