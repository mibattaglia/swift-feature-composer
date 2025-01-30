@testable import FeatureComposer
import Testing

@Suite
struct HotCounterInteractorTests {
    @Test
    func observe() async {
        var state = HotCounterInteractor.State(count: 0)
        let interactor = HotCounterInteractor()
        let result = interactor.transform(state: &state, action: .observe)
        // TODO: - Reacting to the emission should be the responsibility of some controller/store object
        // https://github.com/mibattaglia/swift-feature-composer/issues/4
        switch result.emission {
        case let .concatenate(operation):
            await operation(&state)
        default:
            Issue.record("Expected `concatenate` state")
        }

        #expect(state.count == 9)
    }
}
