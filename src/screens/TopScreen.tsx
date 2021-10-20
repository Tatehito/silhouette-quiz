import { Center, NativeBaseProvider } from 'native-base'
import React, { useState, useEffect } from 'react'
import { Text, View, Button } from 'react-native'

import storage from '../storage/Storage'

export default function ({ navigation }) {
  const [list, setList] = useState<Question[]>([])

  interface Question {
    name: string
  }

  useEffect(
    () =>
      navigation.addListener('focus', () => {
        storage.getAllDataForKey('question').then((questions) => {
          setList(questions)
          // For debug
          console.log(questions)
        })
      }),
    [],
  )

  const handleClickStartQuizButton = () => {}

  const handleClickCreateQuizButton = () => {
    // storage.getIdsForKey('question').then((ids) => {
    //   storage.save({
    //     key: 'question',
    //     id: String(ids.length + 1),
    //     data: {
    //       name: 'nontan' + ids.length,
    //     },
    //   })
    // })
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
        <Text onPress={() => handleClickDeleteButton(3)}>＋もんだいを消す</Text>
      </Center>

      <Center flex={1}>
        <View>
          {list.map((item, index) => (
            <Text key={index}>{item.name}</Text>
          ))}
        </View>
      </Center>
    </NativeBaseProvider>
  )
}
