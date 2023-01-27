import Foundation
import RealmSwift

class Quiz: Object, ObjectKeyIdentifiable {
    @objc dynamic var title: String = ""
    @objc dynamic var questionImageURL: String?
    @objc dynamic var answerImageURL: String?
    
    func create() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }

    func update(title: String, questionImageURL: String, answerImageURL: String) -> Quiz {
        let realm = try! Realm()
        try! realm.write {
            self.title = title
            self.questionImageURL = questionImageURL
            self.answerImageURL = answerImageURL
        }
        return self
    }
}
