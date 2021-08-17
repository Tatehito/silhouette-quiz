import 'react-native-gesture-handler'
import { StatusBar } from 'expo-status-bar'
import React from 'react'
import { SafeAreaProvider } from 'react-native-safe-area-context'

import db from './firebase'
import useCachedResources from './src/hooks/useCachedResources'
import useColorScheme from './src/hooks/useColorScheme'
import Navigation from './src/navigation'

export default function App() {
  db.collection('tasks')
    .get()
    .then((querySnapshot) => {
      querySnapshot.forEach((task) => {
        console.log(`${task.id} => ${task.data().name}`)
      })
    })

  const isLoadingComplete = useCachedResources()
  const colorScheme = useColorScheme()

  if (!isLoadingComplete) {
    return null
  } else {
    return (
      <SafeAreaProvider>
        <Navigation colorScheme={colorScheme} />
        <StatusBar />
      </SafeAreaProvider>
    )
  }
}
