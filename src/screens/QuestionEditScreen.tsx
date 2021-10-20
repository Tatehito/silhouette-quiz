import * as FileSystem from 'expo-file-system'
import { NativeBaseProvider, Center } from 'native-base'
import React from 'react'
import { Text, Image } from 'react-native'

import storage from '../storage/Storage'

const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'

export default function ({ route, navigation }) {
  const { question } = route.params
  const questionImage = documentDir + `'question_image_'${question.id}`
  const answerImage = documentDir + `'answer_image_'${question.id}`

  const handleClickDeleteButton = async () => {
    await storage.remove({
      key: 'question',
      id: String(question.id),
    })
    FileSystem.deleteAsync(questionImage)
    navigation.navigate('Root')
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
