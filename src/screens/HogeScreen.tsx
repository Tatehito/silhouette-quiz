import { Center, NativeBaseProvider } from 'native-base'
import React, { useState, useEffect } from 'react'
import { Text, View } from 'react-native'

export default function () {
  return (
    <NativeBaseProvider>
      <Center flex={1}>
        <View>
          <Text>a</Text>
        </View>
      </Center>
    </NativeBaseProvider>
  )
}
