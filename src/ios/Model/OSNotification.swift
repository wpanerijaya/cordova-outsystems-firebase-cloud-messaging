import CoreData

@objc(OSNotification)
public class OSNotification: NSManagedObject, Codable {
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(messageID: String,
         extraDataList: [OSExtraData],
         timeToLive: String,
         timeStamp: Double,
         context: NSManagedObjectContext) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "OSNotification", in: context)!, insertInto: context)
        self.messageID = messageID
        self.extraDataList = NSSet(array: extraDataList)
        self.timeToLive = timeToLive
        self.timeStamp = timeStamp
    }
    
    enum CodingKeys: String, CodingKey {
        case messageID, extraDataList, timeToLive, timeStamp
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(messageID, forKey: .messageID)
        try container.encode(extraDataList?.allObjects as? [OSExtraData], forKey: .extraDataList)
        try container.encode(timeToLive, forKey: .timeToLive)
        try container.encode(timeStamp, forKey: .timeStamp)
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError()
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let messageID = try container.decode(String.self, forKey: .messageID)
        let extraDataList = try container.decode([OSExtraData].self, forKey: .extraDataList)
        let timeToLive = try container.decode(String.self, forKey: .timeToLive)
        let timeStamp = try container.decode(Double.self, forKey: .timeStamp)
        self.init(messageID: messageID, extraDataList: extraDataList, timeToLive: timeToLive, timeStamp: timeStamp, context: context)
    }
    
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
