@testable import FeatureComposer
import Testing

final class InteractorController<I>: @unchecked Sendable where I: Interactor, I.State == I.Body.State, I.Action == I.Body.Action {
    private var state: I.State
    private let rootInteractor: I.Body
    
    private let stateContinuation: AsyncStream<I.State>.Continuation
    let stateStream: AsyncStream<I.State>

    init(initialState: I.State, interactor: I) {
        self.state = initialState
        self.rootInteractor = interactor.body

        var continuation: AsyncStream<I.State>.Continuation!
        self.stateStream = AsyncStream { continuation = $0 }
        self.stateContinuation = continuation
    }

    func send(_ action: I.Action) {
        let result = rootInteractor.transform(state: &state, action: action)
        print(result)
        stateContinuation.yield(state)  // Emit new state to observers
        handle(result)
    }
    
    func finish() {
        stateContinuation.finish()
    }

    private func handle(_ result: InteractionResult<I.State>) {
        if case .stop = result.emission {
            stateContinuation.finish()
        }
//        switch result.emission {
//        case .state:
//            print(self.state)
//        case .stop:
//            stateContinuation.finish()
//        case .perform(let action):
////            Task {
////                await action(&state)
////            }
//            print("action")
//        }
    }
}

@Suite
struct CounterInteractorTests {
    let interactor = CounterInteractor()
    
    @Test
    func increment() async {
        let state = CounterInteractor.State(count: 0)
        let controller = InteractorController(initialState: state, interactor: interactor)
        
        controller.send(.increment)
        controller.send(.increment)

        var counter = 0
        for await domainState in controller.stateStream {
            counter = domainState.count
        }
        
        controller.finish()

        #expect(counter == 3)
    }

//    @Test
//    func decrement() async {
//        var state = CounterInteractor.State(count: 10)
//        let interactor = CounterInteractor()
//        _ = interactor.transform(state: &state, action: .decrement)
//
//        #expect(state.count == 9)
//    }
//
//    @Test
//    func reset() async {
//        var state = CounterInteractor.State(count: 42)
//        let interactor = CounterInteractor()
//        _ = interactor.transform(state: &state, action: .reset)
//
//        #expect(state.count == 0)
//    }
}
