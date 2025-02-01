@testable import FeatureComposer
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
        var actual: [CounterInteractor.State] = []
        for await domainState in controller.stateStream {
            actual.append(domainState)
            if actual.count == 3 {
                break
            }
        }
        #expect(actual == expected)
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
        var actual: [CounterInteractor.State] = []
        for await domainState in controller.stateStream {
            actual.append(domainState)
            if actual.count == 2 {
                break
            }
        }

        #expect(actual == expected)
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
        var actual: [CounterInteractor.State] = []
        for await domainState in controller.stateStream {
            actual.append(domainState)
            if actual.count == 2 {
                break
            }
        }

        #expect(actual == expected)
    }
}
