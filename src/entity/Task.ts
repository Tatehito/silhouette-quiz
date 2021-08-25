import db from '../../firebase'

class Task {
  id: string
  name: string

  constructor(id: string, name: string) {
    this.id = id
    this.name = name
  }

  static findAll(): Task[] {
    const tasks: Task[] = []

    db.collection('tasks')
      .get()
      .then((querySnapshot) => {
        querySnapshot.forEach((task) => {
          const data = task.data()
          tasks.push(new Task(task.id, data.name))
        })
      })

    return tasks
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
