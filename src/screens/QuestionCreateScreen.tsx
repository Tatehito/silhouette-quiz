import React, { useState, useEffect } from 'react'
import { Text, View } from 'react-native'

export default function ({ navigation }) {
  const handleClickBack = () => {
    navigation.navigate('Root')
  }

  return (
    <View>
      <View>
        <Text onPress={handleClickBack}>もどる</Text>
      </View>
      <Text>a</Text>
    </View>
  )
}
