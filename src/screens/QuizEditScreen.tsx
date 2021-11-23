import * as FileSystem from 'expo-file-system'
import { NativeBaseProvider, Center } from 'native-base'
import React from 'react'
import { Text, Image } from 'react-native'

import useDeleteQuestion from '../hooks/useDeleteQuestion'

export default function ({ route, navigation }) {
  const { question } = route.params
  const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'
  const questionImage = documentDir + `'question_image_'${question.id}`
  const answerImage = documentDir + `'answer_image_'${question.id}`
  const deleteQuestion = useDeleteQuestion()

  const handleClickDeleteButton = () => {
    deleteQuestion(question)
    navigation.navigate('QuizList')
  }

  const handleClickBackButton = () => {
    navigation.goBack()
  }

  return (
    <NativeBaseProvider>
      <Center flex={1}>
        <Text>なまえ</Text>
      </Center>
      <Center flex={1}>
        <Text>{question.name}</Text>
      </Center>
      <Center flex={1}>
        <Text>もんだい</Text>
      </Center>
      <Center flex={1}>
        <Image source={{ uri: questionImage }} style={{ width: 200, height: 200 }} />
      </Center>
      <Center flex={1}>
        <Text>こたえ</Text>
      </Center>
      <Center flex={1}>
        <Image source={{ uri: answerImage }} style={{ width: 200, height: 200 }} />
      </Center>
      <Center flex={1}>
        <Text onPress={() => handleClickDeleteButton()}>さくじょする</Text>
      </Center>
      <Center flex={1}>
        <Text onPress={() => handleClickBackButton()}>もどる</Text>
      </Center>
    </NativeBaseProvider>
  )
}
