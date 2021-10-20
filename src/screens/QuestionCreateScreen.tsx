import * as FileSystem from 'expo-file-system'
import * as ImagePicker from 'expo-image-picker'
import { NativeBaseProvider, Center } from 'native-base'
import React, { useState } from 'react'
import { Text, View, Button, TextInput, Image } from 'react-native'

import storage from '../storage/Storage'

// TODO: 全画面共通の定義にしたい
const tempDir = FileSystem.cacheDirectory + 'silhouette-quiz/'
const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'

export default function ({ navigation }) {
  const [name, setName] = useState<string>('')
  const [questionImage, setQuestionImage] = useState<string>()
  const [answerImage, setAnswerImage] = useState<string>()

  const NameInput = () => {
    return (
      <View>
        <Text>なまえ</Text>
        <TextInput value={name} onChangeText={(value) => setName(value)} />
      </View>
    )
  }

  const handleClickQuestionImagePickButton = async () => {
    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.All,
      allowsEditing: true,
      aspect: [4, 3],
      quality: 1,
    })

    if (!result.cancelled) {
      const to = tempDir + 'question_image'
      await FileSystem.copyAsync({
        from: result.uri,
        to,
      })
      setQuestionImage(to)
    }
  }

  const handleClickAnswerImagePickButton = async () => {
    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.All,
      allowsEditing: true,
      aspect: [4, 3],
      quality: 1,
    })

    if (!result.cancelled) {
      const to = tempDir + 'answer_image'
      await FileSystem.copyAsync({
        from: result.uri,
        to,
      })
      setAnswerImage(to)
    }
  }

  const handleClickSave = () => {
    storage.getIdsForKey('question').then(async (ids) => {
      const nextId = String(ids.length + 1)
      await storage.save({
        key: 'question',
        id: nextId,
        data: {
          id: nextId,
          name,
        },
      })
      await FileSystem.copyAsync({
        from: questionImage,
        to: documentDir + `'question_image_'${nextId}`,
      })
      await FileSystem.copyAsync({
        from: answerImage,
        to: documentDir + `'answer_image_'${nextId}`,
      })
      navigation.navigate('Root')
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
        <Text>もんだい</Text>
        <Button title="しゃしんをえらぶ" onPress={() => handleClickQuestionImagePickButton()} />
      </Center>
      <Center flex={1}>
        <Image source={{ uri: questionImage }} style={{ width: 200, height: 200 }} />
      </Center>
      <Center flex={1}>
        <Text>こたえ</Text>
        <Button title="しゃしんをえらぶ" onPress={() => handleClickAnswerImagePickButton()} />
      </Center>
      <Center flex={1}>
        <Image source={{ uri: answerImage }} style={{ width: 200, height: 200 }} />
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
