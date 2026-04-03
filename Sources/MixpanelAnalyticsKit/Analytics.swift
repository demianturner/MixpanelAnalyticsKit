import Foundation
import Mixpanel
import os.log

public protocol AnalyticsEventType: RawRepresentable where RawValue == String {
    var title: String { get }
}

public enum Analytics {
    private static func log(subsystem: String?) -> Logger {
        Logger(
            subsystem: subsystem ?? Bundle.main.bundleIdentifier ?? "Analytics",
            category: "Analytics"
        )
    }

    public static func configure(
        token: String,
        distinctId: String,
        extraSuperProps: [String: Any] = [:],
        loggerSubsystem: String? = nil
    ) {
        Mixpanel.initialize(token: token, trackAutomaticEvents: false)
        Mixpanel.mainInstance().identify(distinctId: distinctId)
        Mixpanel.mainInstance().loggingEnabled = true

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let platform = defaultPlatformName()

        var superProps: [String: any MixpanelType] = [
            "app_version": appVersion,
            "build": build,
            "platform": platform,
            "source": platform,
            "is_debug": _isDebugAssertConfiguration(),
        ]
        superProps.merge(makeMixpanelProperties(from: extraSuperProps)) { _, new in new }

        Mixpanel.mainInstance().registerSuperProperties(superProps)
        log(subsystem: loggerSubsystem).debug("super properties registered: \(superProps)")
    }

    public static func action<Event: AnalyticsEventType>(
        _ event: Event,
        props: [String: Any] = [:],
        loggerSubsystem: String? = nil
    ) {
        var mixpanelProps: [String: String] = [:]

        for (key, rawValue) in props {
            mixpanelProps[key] = String(describing: rawValue)
        }

        #if !targetEnvironment(simulator)
        Mixpanel.mainInstance().track(event: event.title, properties: mixpanelProps)
        #endif

        let message = "📢📢📢 \(event.title) (.\(event.rawValue))"

        if props.isEmpty {
            log(subsystem: loggerSubsystem).debug("\(message, privacy: .public)")
        } else {
            log(subsystem: loggerSubsystem).debug("\(message, privacy: .public) \(props)")
        }
    }

    static func makeMixpanelProperties(from props: [String: Any]) -> [String: any MixpanelType] {
        var mixpanelProps: [String: any MixpanelType] = [:]

        for (key, value) in props {
            switch value {
            case let value as String:
                mixpanelProps[key] = value
            case let value as Bool:
                mixpanelProps[key] = value
            case let value as Int:
                mixpanelProps[key] = value
            case let value as Double:
                mixpanelProps[key] = value
            case let value as Float:
                mixpanelProps[key] = Double(value)
            default:
                mixpanelProps[key] = String(describing: value)
            }
        }

        return mixpanelProps
    }

    static func defaultPlatformName() -> String {
        #if targetEnvironment(macCatalyst)
        "macCatalyst"
        #elseif os(macOS)
        "macOS"
        #elseif os(iOS)
        "iOS"
        #elseif os(tvOS)
        "tvOS"
        #elseif os(watchOS)
        "watchOS"
        #elseif os(visionOS)
        "visionOS"
        #else
        "unknown"
        #endif
    }
}

public final class AnalyticsID {
    private static let key = "mixpanel_distinct_id"

    public static var current: String {
        if let existing = UserDefaults.standard.string(forKey: key) {
            return existing
        }

        let newID = UUID().uuidString
        UserDefaults.standard.set(newID, forKey: key)
        return newID
    }

    public static func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
