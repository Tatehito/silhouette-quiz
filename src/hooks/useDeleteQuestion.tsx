import * as FileSystem from 'expo-file-system'
import { useEffect } from 'react'

import storage from '../storage/Storage'

const useDeleteQuestion = () => {
  const deleteQuestion = async (question) => {
    const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'
    const questionImage = documentDir + `'question_image_'${question.id}`
    await storage.remove({
      key: 'question',
      id: String(question.id),
    })
    FileSystem.deleteAsync(questionImage)
  }
  return deleteQuestion
}

export default useDeleteQuestion
