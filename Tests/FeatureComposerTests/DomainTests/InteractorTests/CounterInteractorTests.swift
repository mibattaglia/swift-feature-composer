@testable import FeatureComposer
import Testing

@Suite
struct CounterInteractorTests {
    @Test
    func increment() async {
        var state = CounterInteractor.State(count: 0)
        let interactor = CounterInteractor()
        _ = interactor.transform(state: &state, action: .increment)
        _ = interactor.transform(state: &state, action: .increment)

        #expect(state.count == 2)
    }

    @Test
    func decrement() async {
        var state = CounterInteractor.State(count: 10)
        let interactor = CounterInteractor()
        _ = interactor.transform(state: &state, action: .decrement)

        #expect(state.count == 9)
    }

    @Test
    func reset() async {
        var state = CounterInteractor.State(count: 42)
        let interactor = CounterInteractor()
        _ = interactor.transform(state: &state, action: .reset)

        #expect(state.count == 0)
    }
}
