public enum FirebaseEventType {
    case trigger(notification: FirebaseNotificationType)
    case click
}

public enum FirebaseNotificationType {
    case defaultNotification
    case silentNotification
}
