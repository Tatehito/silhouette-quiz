import React from 'react'
import { Button, StyleSheet, View } from 'react-native'

export default function ({ onPress, label }) {
  return (
    <View style={styles.wrapper}>
      <Button onPress={() => onPress()} title={label} color="#ffffff" />
    </View>
  )
}

const styles = StyleSheet.create({
  wrapper: {
    width: 200,
    paddingVertical: 10,
    backgroundColor: '#5DB075',
    borderRadius: 60,
  },
})
