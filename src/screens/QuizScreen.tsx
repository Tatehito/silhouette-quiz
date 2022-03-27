import * as FileSystem from 'expo-file-system'
import React, { useState, useEffect } from 'react'
import { Text, Image, View, StyleSheet, Dimensions } from 'react-native'

import PrimaryButton from '../components/PrimaryButton'

const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'

export default function ({ route, navigation }) {
  const { questions } = route.params
  const [mode, setMode] = useState<string>()
  const [quiz, setQuiz] = useState<Quiz>()

  interface Quiz {
    id: number
    name: string
  }

  useEffect(() => {
    setMode('question')
    selectQuiz()
  }, [])

  const handleClickNextButton = () => {
    if (mode === 'question') {
      setMode('answer')
    } else {
      setMode('question')
      selectQuiz()
    }
  }

  const selectQuiz = async () => {
    // 直前のクイズ以外からランダム選択する
    const nextQuestions = questions.length > 1 ? questions.filter((q) => q !== quiz) : questions
    setQuiz(nextQuestions[Math.floor(Math.random() * nextQuestions.length)])
  }

  const handleClickEndButton = () => {
    navigation.navigate('QuizList')
  }

  return (
    <View style={styles.container}>
      {mode === 'question' && (
        <View>
          <View style={styles.questionImageWrapper}>
            <Image source={{ uri: documentDir + `'question_image_'${quiz.id}` }} style={styles.questionImage} />
            <Text style={styles.questionText}>だーれだ？</Text>
          </View>
          <View style={styles.buttonWrapper}>
            <PrimaryButton onPress={() => handleClickNextButton()} label="こたえをみる" />
          </View>
        </View>
      )}

      {mode === 'answer' && (
        <View>
          <View style={styles.questionImageWrapper}>
            <Image source={{ uri: documentDir + `'answer_image_'${quiz.id}` }} style={styles.questionImage} />
            <Text style={styles.questionText}>{quiz.name}でした！</Text>
          </View>
          <View style={styles.buttonWrapper}>
            <PrimaryButton onPress={() => handleClickNextButton()} label="つぎのもんだい" />
          </View>
        </View>
      )}

      <View style={styles.buttonWrapper}>
        <Text onPress={() => handleClickEndButton()} style={styles.finishButton}>
          クイズをおわる
        </Text>
      </View>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#fff',
    height: Dimensions.get('window').height,
  },
  questionImageWrapper: {
    height: 600,
    marginHorizontal: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  questionImage: {
    width: '100%',
    height: '50%',
    marginBottom: 20,
  },
  questionText: {
    fontSize: 32,
    fontWeight: '500',
  },
  buttonWrapper: {
    alignItems: 'center',
  },
  finishButton: {
    marginTop: 40,
    color: '#5DB075',
    fontSize: 16,
    fontWeight: '500',
  },
})
