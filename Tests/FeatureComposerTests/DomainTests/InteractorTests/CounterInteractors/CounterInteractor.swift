@testable import FeatureComposer
import Testing

struct CounterInteractor: Interactor {
    struct State: Equatable, Sendable {
        var count: Int
    }

    enum Action: Sendable {
        case increment
        case decrement
        case reset
    }
    
    var body: some Interactor<State, Action> {
        Interact<State, Action> { state, action in
            switch action {
            case .increment:
                state.count += 1
                return .state
            case .decrement:
                state.count -= 1
                return .state
            case .reset:
                state.count = 0
                return .stop
            }
        }
    }
}
