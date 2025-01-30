@testable import FeatureComposer
import Foundation

struct HotCounterInteractor: Interactor {
    struct State: Equatable, Sendable {
        var count: Int
    }

    enum Action {
        case observe
    }

    var body: some Interactor<State, Action> {
        Interact<State, Action> { state, action in
            switch action {
            case .observe:
                let stream = AsyncStream { continuation in
                    for i in 1...9 {
                        continuation.yield(i)
                    }

                    continuation.finish()
                }
                return .concatenate { state in
                    for await count in stream {
                        print(count)
                        state.count = count
                    }
                }
            }
        }
    }
}
