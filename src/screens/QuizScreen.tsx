import * as FileSystem from 'expo-file-system'
import { NativeBaseProvider, Center } from 'native-base'
import React, { useState, useEffect } from 'react'
import { Text, Image } from 'react-native'

import storage from '../storage/Storage'

const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'

export default function ({ navigation }) {
  const [mode, setMode] = useState<string>()
  const [quizId, setQuizId] = useState<string>()
  const [image, setImage] = useState<string>()

  useEffect(() => {
    selectQuiz()
    setMode('question')
  }, [])

  useEffect(() => {
    setImage(documentDir + `'${mode}_image_'${quizId}`)
  }, [quizId, mode])

  const handleClickNextButton = () => {
    if (mode === 'question') {
      setMode('answer')
    } else {
      selectQuiz()
      setMode('question')
    }
  }

  const handleClickEndButton = () => {
    navigation.navigate('Root')
  }

  const selectQuiz = async () => {
    // ランダム選択
    const quizIds = await storage.getIdsForKey('question')
    setQuizId(quizIds[Math.floor(Math.random() * quizIds.length)])
  }

  const NextButton = () => {
    return (
      <Text onPress={() => handleClickNextButton()}>{mode === 'question' ? 'こたえをみる' : 'つぎのもんだい'}</Text>
    )
  }

  return (
    <NativeBaseProvider>
      <Center flex={1}>
        <Image source={{ uri: image }} style={{ width: 200, height: 200 }} />
      </Center>
      <Center flex={1}>
        <Text>だーれだ？</Text>
      </Center>
      <Center flex={1}>
        <NextButton />
      </Center>
      <Center flex={1}>
        <Text onPress={() => handleClickEndButton()}>クイズをおわる</Text>
      </Center>
    </NativeBaseProvider>
  )
}
