import * as FileSystem from 'expo-file-system'
import * as ImagePicker from 'expo-image-picker'
import React, { useState } from 'react'
import { Text, View, StyleSheet, Dimensions } from 'react-native'

import QuestionForm from '../components/QuestionForm'
import storage from '../storage/Storage'

// TODO: 全画面共通の定義にしたい
const tempDir = FileSystem.cacheDirectory + 'silhouette-quiz/'
const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'

export default function ({ navigation }) {
  const [name, setName] = useState<string>('')
  const [questionImage, setQuestionImage] = useState<string>()
  const [answerImage, setAnswerImage] = useState<string>()

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
      navigation.navigate('QuizList')
    })
  }

  const handleClickBackButton = () => {
    navigation.goBack()
  }

  return (
    <View style={styles.container}>
      <View style={styles.navbar}>
        <Text onPress={() => handleClickBackButton()} style={styles.backButton}>
          もどる
        </Text>
      </View>
      <QuestionForm
        name={name}
        setName={setName}
        questionImage={questionImage}
        answerImage={answerImage}
        handleClickQuestionImagePickButton={handleClickQuestionImagePickButton}
        handleClickAnswerImagePickButton={handleClickAnswerImagePickButton}
        saveQuestion={handleClickSave}
      />
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#fff',
    height: Dimensions.get('window').height,
  },
  navbar: {
    backgroundColor: '#fff',
    paddingTop: 70,
    paddingHorizontal: 20,
    paddingBottom: 20,
    marginBottom: 20,
    borderBottomColor: '#E8E8E8',
    borderBottomWidth: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  backButton: {
    width: 150,
    color: '#5DB075',
    fontSize: 16,
    fontWeight: '500',
    textAlign: 'left',
  },
})
