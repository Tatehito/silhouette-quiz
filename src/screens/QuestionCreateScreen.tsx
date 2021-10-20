import { NativeBaseProvider, Center } from 'native-base'
import React, { useState, useEffect } from 'react'
import { Text, View, Button, TextInput } from 'react-native'

import storage from '../storage/Storage'

export default function ({ navigation }) {
  const [name, setName] = useState<string>('')

  const NameInput = () => {
    return (
      <View>
        <Text>なまえ</Text>
        <TextInput value={name} onChangeText={(value) => setName(value)} />
      </View>
    )
  }

  const handleClickSave = () => {
    storage.getIdsForKey('question').then((ids) => {
      const nextId = String(ids.length + 1)
      storage
        .save({
          key: 'question',
          id: nextId,
          data: {
            id: nextId,
            name,
          },
        })
        .then(navigation.goBack())
    })
  }

  const handleClickBackButton = () => {
    navigation.goBack()
  }

  return (
    <NativeBaseProvider>
      <Center flex={1}>
        <NameInput />
      </Center>
      <Center flex={1}>
        <Button onPress={() => handleClickSave()} title="ほぞんする" />
      </Center>
      <Center flex={1}>
        <Text onPress={() => handleClickBackButton()}>もどる</Text>
      </Center>
    </NativeBaseProvider>
  )
}
