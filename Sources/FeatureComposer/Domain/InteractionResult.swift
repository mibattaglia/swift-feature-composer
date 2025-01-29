import Foundation

public struct InteractionResult<State> {
    public enum Emission: Sendable {
        case state
        case stop
        // TODO: - https://github.com/mibattaglia/swift-feature-composer/issues/2
        case concatenate(@Sendable (inout State) async -> Void)

        func apply(to state: inout State) async -> Bool {
            switch self {
            case .state:
                return false
            case .stop:
                return true
            case .concatenate(let operation):
                await operation(&state)
                return false
            }
        }
    }

    let emission: Emission

    static func state() -> InteractionResult {
        .init(emission: .state)
    }

    static func stop() -> InteractionResult {
        .init(emission: .stop)
    }

    static func concatenate(_ operation: @Sendable @escaping (inout State) async -> Void) -> InteractionResult {
        .init(emission: .concatenate(operation))
    }
}
