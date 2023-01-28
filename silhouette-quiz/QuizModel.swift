import Foundation
import RealmSwift

class QuizModel: Object, ObjectKeyIdentifiable {
    @objc dynamic var title: String = ""
    @objc dynamic var directoryName: String?
    
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
