import Foundation

public struct InteractionResult<State> {
    public enum Emission {
        case state
        case stop
        // TODO: - https://github.com/mibattaglia/swift-feature-composer/issues/2
        case perform((inout State) async -> Void)
    }

    let emission: Emission

    static var state: InteractionResult {
        InteractionResult(emission: .state)
    }

    static var stop: InteractionResult {
        InteractionResult(emission: .stop)
    }

    static func concatenate(_ operation: @escaping (inout State) async -> Void) -> InteractionResult {
        InteractionResult(emission: .perform(operation))
    }
    
    /// Merges the current result another result into a single result that runs both at the same time.
    ///
    /// - Parameter other: Another result.
    /// - Returns: A result  that runs this result and the other at the same time.
    func merge(with other: Self) -> Self {
        switch (self.emission, other.emission) {
        case (_, .state):
            return self
        case (.state, _):
            return other
        case let (.perform(lhs), .perform(rhs)):
            return .concatenate { state in
                await lhs(&state)
                await rhs(&state)
            }
        case (.perform(let lhs), _):
            return .concatenate(lhs)
        case (_, .perform(let rhs)):
            return .concatenate(rhs)
        case (.stop, .stop):
            return .stop
        }
    }
}
