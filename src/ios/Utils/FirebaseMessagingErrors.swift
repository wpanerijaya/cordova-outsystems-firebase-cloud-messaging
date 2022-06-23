public enum FirebaseMessagingErrors: Int, CustomNSError, LocalizedError {
    
    case registrationError = 100
    case unregistrationError = 101
    case subscriptionError = 102
    case unsubscriptionError = 103
    case obtainingTokenError = 104
    case deletingTokenError = 105
    case settingBadgeNumberError = 106
    case gettingBadgeNumberError = 107
    case requestPermissionsError = 108
    case permissionsDeniedByUser = 109
    case invalidConfigurations = 110
    case errorSendingNotification = 111
    case errorDeletingNotifications = 112
    case errorInsertingNotifications = 113
    case errorObtainingNotifications = 114
    
    public var description: String {
        switch self {
        case .registrationError:
            return "There was an error with the registration"
        case .unregistrationError:
            return "There was an error with the unregistration"
        case .subscriptionError:
            return "There was an error subscribing to topic."
        case .unsubscriptionError:
            return "There was an error unsubscribing to topic."
        case .obtainingTokenError:
            return "There was an error to obtain token."
        case .deletingTokenError:
            return "There was an error to delete token."
        case .settingBadgeNumberError:
            return "There was an error to set the badge number."
        case .gettingBadgeNumberError:
            return "There was an error to obtain the badge number."
        case .requestPermissionsError:
            return "There was an error requesting permissions to send notifications."
        case .permissionsDeniedByUser:
            return "Notifications permission is not granted."
        case .invalidConfigurations:
            return "Invalid configurations."
        case .errorSendingNotification:
            return "There was an error sending the notification."
        case .errorDeletingNotifications:
            return "There was an error deleting the notifications."
        case .errorInsertingNotifications:
            return "There was an error inserting the notifications."
        case .errorObtainingNotifications:
            return "There was an error obtaining the notifications."
        }
    }
    
    public var errorDescription: String? {
        return description.isEmpty ? NSLocalizedString(String(rawValue), comment: "") : description
    }

}
