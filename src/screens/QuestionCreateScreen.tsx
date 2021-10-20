import { NativeBaseProvider } from 'native-base'
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

  const SaveButton = () => {
    return <Button onPress={handleClickSave} title="ほぞんする" />
  }

  const handleClickBack = () => {
    navigation.goBack()
  }

  const handleClickSave = () => {
    storage.save({
      key: 'hoge',
      id: '1001',
      data: 'aaaabbbb',
    })
  }

  return (
    <NativeBaseProvider>
      <View>
        <NameInput />
        <SaveButton />
      </View>
      <View>
        <Text onPress={handleClickBack}>もどる</Text>
      </View>
    </NativeBaseProvider>
  )
}
