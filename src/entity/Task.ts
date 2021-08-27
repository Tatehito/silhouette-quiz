import db from '../../firebase'

class Task {
  id: string
  name: string
  categoryId: string

  constructor(id: string, name: string, categoryId: string) {
    this.id = id
    this.name = name
    this.categoryId = categoryId
  }

  static async getAll(): Promise<Task[]> {
    return new Promise((resolve, reject) => {
      db.collection('tasks')
        .get()
        .then((querySnapshot) => {
          const tasks: Task[] = []
          querySnapshot.forEach((doc) => {
            tasks.push(new Task(doc.id, doc.data().name, doc.data().categoryId))
          })
          resolve(tasks)
        })
        .catch((error) => {
          reject(error)
        })
    })
  }

  create(): void {
    db.collection('tasks')
      .add({ name: this.name, categoryId: this.categoryId })
      .then((doc) => {
        this.id = doc.id
      })
  }

  delete(): void {
    db.collection('tasks').doc(this.id).delete()
  }
}

export default Task
