import Foundation
import ScreenSaver

struct Preferences {
    @Storage(key: "theme", defaultValue: "Classic")
    static var theme: String
    
    @Storage(key: "mines", defaultValue: 1)
    static var mines: Int
}

@propertyWrapper struct Storage<T> {
    private let key: String
    private let defaultValue: T
    private let module = Bundle.main.bundleIdentifier!
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            if let userDefaults = ScreenSaverDefaults(forModuleWithName: module) {
                return userDefaults.object(forKey: key) as? T ?? defaultValue
            }

            return defaultValue
        }
        set {
            if let userDefaults = ScreenSaverDefaults(forModuleWithName: module) {
                userDefaults.set(newValue, forKey: key)

                userDefaults.synchronize()
            }
        }
    }
}

