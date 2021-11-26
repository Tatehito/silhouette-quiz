import { NativeBaseProvider, Input } from 'native-base'
import React from 'react'
import { Text, StyleSheet, View, Image } from 'react-native'

import PrimaryButton from '../components/PrimaryButton'

export default function ({
  name,
  setName,
  questionImage,
  answerImage,
  handleClickQuestionImagePickButton,
  handleClickAnswerImagePickButton,
  saveQuestion,
}) {
  const handleClickSave = async () => {
    if (!name) {
      alert('なまえを入力してね')
      return
    }
    if (!questionImage) {
      alert('もんだいのしゃしんを選んでね')
      return
    }
    if (!answerImage) {
      alert('こたえのしゃしんを選んでね')
      return
    }
    saveQuestion()
  }

  return (
    <NativeBaseProvider>
      <View style={styles.content}>
        <View style={styles.inputWrapper}>
          <View style={styles.label}>
            <Text style={styles.labelText}>なまえ</Text>
          </View>
          <Input value={name} onChangeText={(value) => setName(value)} />
        </View>
        <View style={styles.inputWrapper}>
          <View style={styles.label}>
            <Text style={styles.labelText}>もんだい</Text>
            <Text onPress={() => handleClickQuestionImagePickButton()} style={styles.imagePickButton}>
              しゃしんをえらぶ
            </Text>
          </View>
          <Image source={{ uri: questionImage }} style={{ width: 170, height: 170 }} />
        </View>
        <View style={styles.inputWrapper}>
          <View style={styles.label}>
            <Text style={styles.labelText}>こたえ</Text>
            <Text onPress={() => handleClickAnswerImagePickButton()} style={styles.imagePickButton}>
              しゃしんをえらぶ
            </Text>
          </View>
          <Image source={{ uri: answerImage }} style={{ width: 170, height: 170 }} />
        </View>
        <View style={styles.saveButtonWrapper}>
          <PrimaryButton onPress={() => handleClickSave()} label="ほぞんする" />
        </View>
      </View>
    </NativeBaseProvider>
  )
}

const styles = StyleSheet.create({
  content: {
    backgroundColor: '#fff',
    paddingHorizontal: 20,
  },
  inputWrapper: {
    marginBottom: 40,
  },
  label: {
    flexDirection: 'row',
    marginBottom: 10,
  },
  labelText: {
    fontSize: 16,
    marginRight: 10,
  },
  imagePickButton: {
    fontSize: 16,
    color: '#5DB075',
    fontWeight: '500',
  },
  saveButtonWrapper: {
    alignItems: 'center',
  },
})
