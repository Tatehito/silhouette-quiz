import Foundation
import RealmSwift

class QuizModel: Object, ObjectKeyIdentifiable {
    @objc dynamic var directoryName: String = ""
    @objc dynamic var title: String = ""
    
    override static func primaryKey() -> String? {
        return "directoryName"
    }
    
    func create() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }

    func update(title: String) -> QuizModel {
        let realm = try! Realm()
        try! realm.write {
            self.title = title
        }
        return self
    }
}
