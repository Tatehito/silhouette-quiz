import Foundation
import RealmSwift

class Quiz: Object, ObjectKeyIdentifiable {
    @objc dynamic var title: String = ""
    
    class func create(title: String) -> Quiz {
        let realm = try! Realm()
        let q = Quiz()
        q.title = title
        try! realm.write {
            realm.add(q)
        }
        return q
    }

    func update(title: String) -> Quiz {
        let realm = try! Realm()
        try! realm.write {
            self.title = title
        }
        return self
    }
}
