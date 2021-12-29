import * as FileSystem from 'expo-file-system'
import * as ImagePicker from 'expo-image-picker'
import React, { useState, useEffect } from 'react'
import { View, Dimensions, StyleSheet, Text, Platform } from 'react-native'

import PrimaryButton from '../components/PrimaryButton'
import SwipableList from '../components/SwipableList'
import storage from '../storage/Storage'

const tempDir = FileSystem.cacheDirectory + 'silhouette-quiz/'
const documentDir = FileSystem.documentDirectory + 'silhouette-quiz/'

export default function ({ navigation }) {
  const [questions, setQuestions] = useState<Question[]>([])

  interface Question {
    id: number
    name: string
  }

  useEffect(() => {
    navigation.addListener('focus', () => {
      storage.getAllDataForKey('question').then((questions) => {
        setQuestions(questions)
      })
    })

    FileSystem.getInfoAsync(tempDir).then((dirInfo) => {
      if (!dirInfo.exists) {
        FileSystem.makeDirectoryAsync(tempDir, { intermediates: true })
      }
    })

    FileSystem.getInfoAsync(documentDir).then((dirInfo) => {
      if (!dirInfo.exists) {
        FileSystem.makeDirectoryAsync(documentDir, { intermediates: true })
      }
    })

    if (Platform.OS !== 'web') {
      ImagePicker.requestMediaLibraryPermissionsAsync().then((status) => {
        if (!status.granted) {
          alert('Sorry, we need camera roll permissions to make this work!')
        }
      })
    }
  }, [])

  const handleClickStartQuizButton = () => {
    navigation.navigate('Quiz', {
      questions,
    })
  }

  const handleClickCreateQuizButton = () => {
    navigation.navigate('QuestionCreate')
  }

  const handleClickQuestion = (question: Question) => {
    navigation.navigate('QuestionEdit', {
      question,
    })
  }

  return (
    <View style={styles.container}>
      <View style={styles.navbar}>
        <Text onPress={() => handleClickCreateQuizButton()} style={styles.createQuizButton}>
          ＋もんだいをつくる
        </Text>
      </View>
      <View style={styles.questionList}>
        <SwipableList dataList={questions} setDataList={setQuestions} handleClickItem={handleClickQuestion} />
      </View>
      <View style={styles.startButtonWrapper}>
        <PrimaryButton
          onPress={() => handleClickStartQuizButton()}
          label="クイズをはじめる"
          disabled={questions.length <= 0}
        />
      </View>
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
    justifyContent: 'flex-end',
  },
  createQuizButton: {
    width: 140,
    color: '#5DB075',
    fontSize: 16,
    fontWeight: '500',
    textAlign: 'right',
  },
  questionList: {
    height: Dimensions.get('window').height - 350,
    backgroundColor: '#fff',
    marginBottom: 40,
  },
  startButtonWrapper: {
    alignItems: 'center',
  },
})
