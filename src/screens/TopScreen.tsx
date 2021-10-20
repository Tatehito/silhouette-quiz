import { Center, NativeBaseProvider } from 'native-base'
import React, { useState, useEffect } from 'react'
import { Text, View, Button } from 'react-native'

import storage from '../storage/Storage'

export default function ({ navigation }) {
  const [questions, setQuestions] = useState<Question[]>([])

  interface Question {
    id: number
    name: string
  }

  useEffect(
    () =>
      navigation.addListener('focus', () => {
        storage.getAllDataForKey('question').then((questions) => {
          setQuestions(questions)
          // For debug
          console.log(questions)
        })
      }),
    [],
  )

  const handleClickStartQuizButton = () => {}

  const handleClickCreateQuizButton = () => {
    navigation.navigate('QuestionCreate')
  }

  const handleClickDeleteButton = (id: number) => {
    storage.remove({
      key: 'question',
      id: String(id),
    })
  }

  return (
    <NativeBaseProvider>
      <Center flex={1}>
        <Button onPress={() => handleClickStartQuizButton()} title="クイズをはじめる" />
      </Center>
      <Center flex={1}>
        <Text onPress={() => handleClickCreateQuizButton()}>＋もんだいをつくる</Text>
      </Center>

      <Center flex={1}>
        <View>
          {questions.map((question, index) => (
            <Text key={index} onPress={() => handleClickDeleteButton(question.id)}>
              {question.name}
            </Text>
          ))}
        </View>
      </Center>
    </NativeBaseProvider>
  )
}
