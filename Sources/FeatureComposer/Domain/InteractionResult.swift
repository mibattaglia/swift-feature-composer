import Foundation

public struct InteractionResult<State> {
    public enum Emission {
        case state
        case stop
        // TODO: - https://github.com/mibattaglia/swift-feature-composer/issues/2
        case concatenate((inout State) async -> Void)
    }

    let emission: Emission

    static var state: InteractionResult {
        InteractionResult(emission: .state)
    }

    static var stop: InteractionResult {
        InteractionResult(emission: .stop)
    }

    static func concatenate(_ operation: @escaping (inout State) async -> Void) -> InteractionResult {
        InteractionResult(emission: .concatenate(operation))
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
        case let (.concatenate(lhs), .concatenate(rhs)):
            return .concatenate { state in
                await lhs(&state)
                await rhs(&state)
            }
        case (.concatenate(let lhs), _):
            return .concatenate(lhs)
        case (_, .concatenate(let rhs)):
            return .concatenate(rhs)
        case (.stop, .stop):
            return .stop
        }
    }
}
