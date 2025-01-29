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

    @Test
    func concatenate() async {
        let operation: @Sendable (inout CounterInteractor.State) async -> Void = { state in
            state.count += 10
        }
        var state = CounterInteractor.State(count: 5)
        _ = InteractionResult<CounterInteractor.State>.concatenate(operation)
        await operation(&state)
        #expect(state.count == 15)
    }
}
