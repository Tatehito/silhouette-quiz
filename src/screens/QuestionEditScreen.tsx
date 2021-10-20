import { NativeBaseProvider, Center } from 'native-base'
import React from 'react'
import { Text } from 'react-native'

import storage from '../storage/Storage'

export default function ({ route, navigation }) {
  const { question } = route.params

  const handleClickDeleteButton = () => {
    storage
      .remove({
        key: 'question',
        id: String(question.id),
      })
      .then(navigation.navigate('Root'))
  }

  const handleClickBackButton = () => {
    navigation.goBack()
  }

  return (
    <NativeBaseProvider>
      <Center flex={1}>
        <Text>{question.name}</Text>
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
