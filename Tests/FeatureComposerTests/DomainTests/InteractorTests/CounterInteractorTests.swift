@testable import FeatureComposer
import FeatureComposerTestingSupport
import Foundation
import Testing

@Suite
struct CounterInteractorTests {
    let interactor = CounterInteractor()
    
    @Test
    func increment() async {
        let state = CounterInteractor.State(count: 0)
        let controller = DomainController(initialState: state, interactor: interactor)
        
        controller.send(.increment)
        controller.send(.increment)
        
        let expected = [
            CounterInteractor.State(count: 0),
            CounterInteractor.State(count: 1),
            CounterInteractor.State(count: 2)
        ]
        await streamConfirmation(stream: controller.stateStream, expectedResult: expected)
    }

    @Test
    func decrement() async {
        let state = CounterInteractor.State(count: 10)

        let controller = DomainController(initialState: state, interactor: interactor)
        controller.send(.decrement)
        
        let expected = [
            CounterInteractor.State(count: 10),
            CounterInteractor.State(count: 9)
        ]
        await streamConfirmation(stream: controller.stateStream, expectedResult: expected)
    }
    
    @Test
    func reset() async {
        let state = CounterInteractor.State(count: 42)

        let controller = DomainController(initialState: state, interactor: interactor)
        controller.send(.reset)
        
        let expected = [
            CounterInteractor.State(count: 42),
            CounterInteractor.State(count: 0)
        ]
        await streamConfirmation(stream: controller.stateStream, expectedResult: expected)
    }
}
