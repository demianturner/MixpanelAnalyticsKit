# MixpanelAnalyticsKit

Reusable Mixpanel analytics wiring for Swift apps on iOS and macOS.

`MixpanelAnalyticsKit` keeps the analytics client setup and event dispatch generic, while letting each app define its own event enum locally. Default super properties now derive the runtime platform automatically, so macOS apps report `macOS` instead of inheriting iOS-specific metadata.

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
