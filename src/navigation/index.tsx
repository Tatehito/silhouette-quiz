import { NavigationContainer } from '@react-navigation/native'
import { createStackNavigator } from '@react-navigation/stack'
import * as React from 'react'

import TabOneScreen from '../screens/TopScreen'
import { RootStackParamList } from '../types'
// import LinkingConfiguration from './LinkingConfiguration'

export default function Navigation() {
  return (
    <NavigationContainer
    // linking={LinkingConfiguration}
    >
      <RootNavigator />
    </NavigationContainer>
  )
}

const Stack = createStackNavigator<RootStackParamList>()

function RootNavigator() {
  return (
    <Stack.Navigator screenOptions={{ headerShown: true }}>
      <Stack.Screen name="Root" component={TabOneScreen} />
    </Stack.Navigator>
  )
}
