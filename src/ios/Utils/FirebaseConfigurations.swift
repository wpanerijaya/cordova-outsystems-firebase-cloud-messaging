import UserNotifications

public class FirebaseConfiguration {
    private let fileName: String
    private let bundle: Bundle
    public static let googleServicesFileName = "GoogleService-Info"

    public init(fileName: String = googleServicesFileName, bundle: Bundle = Bundle.main) {
        self.fileName = fileName
        self.bundle = bundle
    }
    
    public func getGoogleServicesPath() -> String? {
        return self.bundle.path(forResource: self.fileName, ofType: "plist")
    }
}
