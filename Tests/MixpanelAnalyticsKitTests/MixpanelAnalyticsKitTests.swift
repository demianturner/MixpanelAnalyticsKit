import Testing
@testable import MixpanelAnalyticsKit

private enum StubEvent: String, AnalyticsEventType {
    case started
    case finished

    var title: String {
        switch self {
        case .started: "Started"
        case .finished: "Finished"
        }
    }
}

@Suite("MixpanelAnalyticsKit")
struct MixpanelAnalyticsKitTests {
    @Test("AnalyticsID persists until reset")
    func analyticsIDPersistsUntilReset() {
        AnalyticsID.reset()

        let first = AnalyticsID.current
        let second = AnalyticsID.current

        #expect(first == second)

        AnalyticsID.reset()
        let third = AnalyticsID.current

        #expect(first != third)
    }

    @Test("Analytics action accepts event types with properties")
    func analyticsActionAcceptsEventTypes() {
        Analytics.configure(
            token: "test_token",
            distinctId: "test_distinct_id"
        )
        Analytics.action(StubEvent.started)
        Analytics.action(StubEvent.finished, props: ["count": 2, "enabled": true])
    }

    @Test("Analytics configure accepts generic super properties")
    func analyticsConfigureAcceptsGenericSuperProperties() {
        Analytics.configure(
            token: "test_token",
            distinctId: "test_distinct_id",
            extraSuperProps: [
                "flag": true,
                "build_number": 42,
                "note": "hello"
            ]
        )
    }
}
