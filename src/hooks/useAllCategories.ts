import { useState, useEffect } from 'react'

import Category from '../entity/Category'

const useAllCategories = () => {
  const [category, setCategory] = useState<Category[]>([])

  useEffect(() => {
    Category.getAll()
      .then((categories) => {
        setCategory(categories)
      })
      .catch((error) => {
        console.error(error)
      })
  }, [])

  return category
}

export default useAllCategories
