import { NavigationContainer } from '@react-navigation/native'
import { createStackNavigator } from '@react-navigation/stack'
import * as React from 'react'

import QuestionCreateScreen from '../screens/QuizCreateScreen'
import QuestionEditScreen from '../screens/QuizEditScreen'
import QuizListScreen from '../screens/QuizListScreen'
import QuizScreen from '../screens/QuizScreen'
import { RootStackParamList } from '../types'
const Stack = createStackNavigator<RootStackParamList>()

export default function Navigation() {
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="QuizList" component={QuizListScreen} />
        <Stack.Screen name="Quiz" component={QuizScreen} />
        <Stack.Screen name="QuestionCreate" component={QuestionCreateScreen} />
        <Stack.Screen name="QuestionEdit" component={QuestionEditScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}
