import { NavigationContainer } from '@react-navigation/native'
import { createStackNavigator } from '@react-navigation/stack'
import * as React from 'react'

import HogeScreen from '../screens/HogeScreen'
import TabOneScreen from '../screens/TopScreen'
import { RootStackParamList } from '../types'
const Stack = createStackNavigator<RootStackParamList>()

export default function Navigation() {
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="root" component={TabOneScreen} />
        <Stack.Screen name="QuestionCreate" component={HogeScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}
