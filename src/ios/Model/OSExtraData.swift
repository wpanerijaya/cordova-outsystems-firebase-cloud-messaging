import Foundation
import CoreData

@objc(OSExtraData)
public class OSExtraData: NSManagedObject, Codable {

    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(key: String,
         value: String,
         context: NSManagedObjectContext) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "OSExtraData", in: context)!, insertInto: context)
        self.key = key
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case key, value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(value, forKey: .value)
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError()
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = try container.decode(String.self, forKey: .key)
        let value = try container.decode(String.self, forKey: .value)
        self.init(key: key, value: value, context: context)
    }
    
}
