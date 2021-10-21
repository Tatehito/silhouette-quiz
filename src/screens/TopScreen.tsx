import * as FileSystem from 'expo-file-system'
import * as ImagePicker from 'expo-image-picker'
import { Center, NativeBaseProvider } from 'native-base'
import React, { useState, useEffect } from 'react'
import { Text, View, Button, Platform } from 'react-native'

import storage from '../storage/Storage'

const tempDir = FileSystem.cacheDirectory + 'silhouette-quiz/'
const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'

export default function ({ navigation }) {
  const [questions, setQuestions] = useState<Question[]>([])

  interface Question {
    id: number
    name: string
  }

  useEffect(() => {
    navigation.addListener('focus', () => {
      storage.getAllDataForKey('question').then((questions) => {
        setQuestions(questions)
        // For debug
        console.log(questions)
      })
    })

    FileSystem.getInfoAsync(tempDir).then((dirInfo) => {
      if (!dirInfo.exists) {
        FileSystem.makeDirectoryAsync(tempDir, { intermediates: true })
      }
    })

    FileSystem.getInfoAsync(documentDir).then((dirInfo) => {
      if (!dirInfo.exists) {
        FileSystem.makeDirectoryAsync(documentDir, { intermediates: true })
      }
    })

    if (Platform.OS !== 'web') {
      ImagePicker.requestMediaLibraryPermissionsAsync().then((status) => {
        if (!status.granted) {
          alert('Sorry, we need camera roll permissions to make this work!')
        }
      })
    }
  }, [])

  const handleClickStartQuizButton = () => {
    navigation.navigate('Quiz')
  }

  const handleClickCreateQuizButton = () => {
    navigation.navigate('QuestionCreate')
  }

  const handleClickQuestion = (question: Question) => {
    navigation.navigate('QuestionEdit', {
      question,
    })
  }

  return (
    <NativeBaseProvider>
      <Center flex={1}>
        <Text onPress={() => handleClickCreateQuizButton()}>＋もんだいをつくる</Text>
      </Center>
      <Center flex={1}>
        <View>
          {questions.map((question, index) => (
            <Text key={index} onPress={() => handleClickQuestion(question)}>
              {question.name}
            </Text>
          ))}
        </View>
      </Center>
      <Center flex={1}>
        <Button onPress={() => handleClickStartQuizButton()} title="クイズをはじめる" />
      </Center>
    </NativeBaseProvider>
  )
}
