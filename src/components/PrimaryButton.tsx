import React from 'react'
import { Button, View } from 'react-native'

export default function ({ onPress, label, disabled = false }) {
  const style = (disabled: boolean) => {
    return {
      width: 200,
      paddingVertical: 10,
      backgroundColor: disabled ? '#a5a5a5' : '#5DB075',
      borderRadius: 60,
    }
  }

  return (
    <View style={style(disabled)}>
      <Button onPress={() => onPress()} title={label} color="#ffffff" disabled={disabled} />
    </View>
  )
}
