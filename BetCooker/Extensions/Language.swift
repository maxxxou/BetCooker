import Foundation

private var bundleKey: UInt8 = 0

final class LocalizedBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = Bundle.main.path(forResource: Bundle.currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }

        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static var currentLanguage: String = "en"

    class func setLanguage(_ language: String) {
        currentLanguage = language
        object_setClass(Bundle.main, LocalizedBundle.self)
    }
}
