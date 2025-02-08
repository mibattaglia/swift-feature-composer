@testable import FeatureComposer
import Testing

@Suite
struct HotCounterInteractorTests {
    @Test
    func observe() async {
        let state = HotCounterInteractor.State(count: 0)
        let interactor = HotCounterInteractor()
        let controller = DomainController(initialState: state, interactor: interactor)
        
        controller.send(.observe)
        let expected = [
            HotCounterInteractor.State(count: 0),
            HotCounterInteractor.State(count: 0),
            HotCounterInteractor.State(count: 1),
            HotCounterInteractor.State(count: 2),
            HotCounterInteractor.State(count: 3),
            HotCounterInteractor.State(count: 4),
            HotCounterInteractor.State(count: 5),
            HotCounterInteractor.State(count: 6),
            HotCounterInteractor.State(count: 7),
            HotCounterInteractor.State(count: 8),
            HotCounterInteractor.State(count: 9)
        ]
        var actual: [HotCounterInteractor.State] = []
        for await domainState in controller.stateStream {
            actual.append(domainState)
            if actual.count == 11 {
                break
            }
        }
        #expect(actual == expected)
    }
}
