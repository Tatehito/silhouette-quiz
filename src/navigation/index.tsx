import { NavigationContainer } from '@react-navigation/native'
import { createStackNavigator } from '@react-navigation/stack'
import * as React from 'react'

import QuestionCreateScreen from '../screens/QuestionCreateScreen'
import QuestionEditScreen from '../screens/QuestionEditScreen'
import QuizScreen from '../screens/QuizScreen'
import TopScreen from '../screens/TopScreen'
import { RootStackParamList } from '../types'
const Stack = createStackNavigator<RootStackParamList>()

export default function Navigation() {
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="Root" component={TopScreen} />
        <Stack.Screen name="Quiz" component={QuizScreen} />
        <Stack.Screen name="QuestionCreate" component={QuestionCreateScreen} />
        <Stack.Screen name="QuestionEdit" component={QuestionEditScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}
