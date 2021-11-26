import * as FileSystem from 'expo-file-system'
import React, { useState } from 'react'
import { Text, View, StyleSheet, Dimensions } from 'react-native'

import QuestionForm from '../components/QuestionForm'
import useDeleteQuestion from '../hooks/useDeleteQuestion'
import storage from '../storage/Storage'

// TODO: 全画面共通の定義にしたい
const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'

export default function ({ route, navigation }) {
  const { question } = route.params
  const [name, setName] = useState<string>(question.name)
  const [questionImage, setQuestionImage] = useState<string>(documentDir + `'question_image_'${question.id}`)
  const [answerImage, setAnswerImage] = useState<string>(documentDir + `'answer_image_'${question.id}`)
  const deleteQuestion = useDeleteQuestion()

  const handleClickDeleteButton = () => {
    deleteQuestion(question)
    navigation.navigate('QuizList')
  }

  const handleClickBackButton = () => {
    navigation.goBack()
  }

  const handleClickSave = async () => {
    await storage.save({
      key: 'question',
      id: question.id,
      data: {
        id: question.id,
        name,
      },
    })
    await FileSystem.copyAsync({
      from: questionImage,
      to: documentDir + `'question_image_'${question.id}`,
    })
    await FileSystem.copyAsync({
      from: answerImage,
      to: documentDir + `'answer_image_'${question.id}`,
    })
    navigation.navigate('QuizList')
  }

  return (
    <View style={styles.container}>
      <View style={styles.navbar}>
        <Text onPress={() => handleClickBackButton()} style={styles.backButton}>
          もどる
        </Text>
        <Text onPress={() => handleClickDeleteButton()} style={styles.deleteButton}>
          さくじょする
        </Text>
      </View>
      <QuestionForm
        name={name}
        setName={setName}
        questionImage={questionImage}
        setQuestionImage={setQuestionImage}
        answerImage={answerImage}
        setAnswerImage={setAnswerImage}
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
  deleteButton: {
    width: 150,
    color: '#FF0000',
    fontSize: 16,
    fontWeight: '500',
    textAlign: 'right',
  },
})
