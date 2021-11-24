import * as FileSystem from 'expo-file-system'
import React, { useState, useEffect } from 'react'
import { Text, Image, View, StyleSheet, Dimensions } from 'react-native'

import PrimaryButton from '../components/PrimaryButton'
import storage from '../storage/Storage'

const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'

export default function ({ navigation }) {
  const [mode, setMode] = useState<string>()
  const [quizId, setQuizId] = useState<string>()
  const [image, setImage] = useState<string>()

  useEffect(() => {
    selectQuiz()
    setMode('question')
  }, [])

  useEffect(() => {
    setImage(documentDir + `'${mode}_image_'${quizId}`)
  }, [quizId, mode])

  const handleClickNextButton = () => {
    if (mode === 'question') {
      setMode('answer')
    } else {
      selectQuiz()
      setMode('question')
    }
  }

  const handleClickEndButton = () => {
    navigation.navigate('QuizList')
  }

  const selectQuiz = async () => {
    // ランダム選択
    const quizIds = await storage.getIdsForKey('question')
    setQuizId(quizIds[Math.floor(Math.random() * quizIds.length)])
  }

  return (
    <View style={styles.container}>
      <View style={styles.questionImageWrapper}>
        <Image source={{ uri: image }} style={styles.questionImage} />
        <Text style={styles.questionText}>だーれだ？</Text>
      </View>
      <View style={styles.buttonWrapper}>
        <PrimaryButton
          onPress={() => handleClickNextButton()}
          label={mode === 'question' ? 'こたえをみる' : 'つぎのもんだい'}
        />
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
