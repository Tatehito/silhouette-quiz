import * as FileSystem from 'expo-file-system'
import React from 'react'
import { Text, Image, StyleSheet, View } from 'react-native'

import useDeleteQuestion from '../hooks/useDeleteQuestion'

export default function ({ route, navigation }) {
  const { question } = route.params
  const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'
  const questionImage = documentDir + `'question_image_'${question.id}`
  const answerImage = documentDir + `'answer_image_'${question.id}`
  const deleteQuestion = useDeleteQuestion()

  const handleClickDeleteButton = () => {
    deleteQuestion(question)
    navigation.navigate('QuizList')
  }

  const handleClickBackButton = () => {
    navigation.goBack()
  }

  return (
    <View>
      <View style={styles.navbar}>
        <Text onPress={() => handleClickBackButton()} style={styles.backButton}>
          もどる
        </Text>
        <Text onPress={() => handleClickDeleteButton()} style={styles.deleteButton}>
          さくじょする
        </Text>
      </View>
      <View>
        <Text>なまえ</Text>
      </View>
      <View>
        <Text>{question.name}</Text>
      </View>
      <View>
        <Text>もんだい</Text>
      </View>
      <View>
        <Image source={{ uri: questionImage }} style={{ width: 200, height: 200 }} />
      </View>
      <View>
        <Text>こたえ</Text>
      </View>
      <View>
        <Image source={{ uri: answerImage }} style={{ width: 200, height: 200 }} />
      </View>
    </View>
  )
}

const styles = StyleSheet.create({
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
