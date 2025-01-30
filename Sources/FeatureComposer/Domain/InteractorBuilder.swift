import Foundation

// TODO: - https://github.com/mibattaglia/swift-feature-composer/issues/3
@resultBuilder
public struct InteractorBuilder<State: Equatable, Action> {
    public static func buildBlock<T: Interactor<State, Action>>(_ transformer: T) -> T {
        transformer
    }
}
