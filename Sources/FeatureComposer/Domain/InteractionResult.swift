import Foundation

public struct InteractionResult<State> {
    public enum Emission: Sendable {
        case state
        case stop
        // TODO: - https://github.com/mibattaglia/swift-feature-composer/issues/2
        case concatenate(@Sendable (inout State) async -> Void)
    }

    let emission: Emission

    static var state: InteractionResult {
        InteractionResult(emission: .state)
    }

    static var stop: InteractionResult {
        InteractionResult(emission: .stop)
    }

    static func concatenate(_ operation: @Sendable @escaping (inout State) async -> Void) -> InteractionResult {
        InteractionResult(emission: .concatenate(operation))
    }
}
