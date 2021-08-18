import 'react-native-gesture-handler'
import { StatusBar } from 'expo-status-bar'
import React from 'react'
import { SafeAreaProvider } from 'react-native-safe-area-context'

import db from './firebase'
import Navigation from './src/navigation'

export default function App() {
  db.collection('tasks')
    .get()
    .then((querySnapshot) => {
      querySnapshot.forEach((task) => {
        console.log(`${task.id} => ${task.data().name}`)
      })
    })

  return (
    <SafeAreaProvider>
      <Navigation />
      <StatusBar />
    </SafeAreaProvider>
  )
}
