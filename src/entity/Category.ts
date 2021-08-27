import db from '../../firebase'

const collectionName = 'categories'

class Category {
  id: string
  name: string

  constructor(id: string, name: string) {
    this.id = id
    this.name = name
  }

  static async getAll(): Promise<Category[]> {
    return new Promise((resolve, reject) => {
      db.collection(collectionName)
        .get()
        .then((querySnapshot) => {
          const tasks: Category[] = []
          querySnapshot.forEach((doc) => {
            tasks.push(new Category(doc.id, doc.data().name))
          })
          resolve(tasks)
        })
        .catch((error) => {
          reject(error)
        })
    })
  }
}

export default Category
