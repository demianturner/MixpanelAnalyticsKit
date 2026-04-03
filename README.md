# MixpanelAnalyticsKit

Reusable Mixpanel analytics wiring for Swift apps.

`MixpanelAnalyticsKit` keeps the analytics client setup and event dispatch generic, while letting each app define its own event enum locally.

## Usage

```swift
import MixpanelAnalyticsKit

enum AnalyticsEvent: String, AnalyticsEventType {
    case appOpened

    var title: String {
        switch self {
        case .appOpened: "App Opened"
        }
    }
}

Analytics.configure(
    token: "<mixpanel-token>",
    distinctId: AnalyticsID.current
)

Analytics.action(AnalyticsEvent.appOpened)
```

Project-specific event definitions should live in the host app, not in this package.
