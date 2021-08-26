import db from '../../firebase'

class Task {
  id: string
  name: string

  constructor(id: string, name: string) {
    this.id = id
    this.name = name
  }

  static async getAll(): Promise<Task[]> {
    return new Promise((resolve, reject) => {
      db.collection('tasks')
        .get()
        .then((querySnapshot) => {
          const tasks: Task[] = []
          querySnapshot.forEach((doc) => {
            tasks.push(new Task(doc.id, doc.data().name))
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
      .add({ name: this.name })
      .then((doc) => {
        this.id = doc.id
      })
  }

  delete(): void {
    db.collection('tasks').doc(this.id).delete()
  }
}

export default Task
