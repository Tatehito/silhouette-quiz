import { FontAwesome5 } from '@expo/vector-icons'
import { Input, IconButton, VStack, Icon, Center, NativeBaseProvider } from 'native-base'
import React, { useState } from 'react'
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native'

import Task from '../../entity/Task'
import SwapableList from '../molecules/SwaipableList'

export default () => {
  const [list, setList] = useState<Task[]>(Task.findAll())
  const [inputValue, setInputValue] = useState('')

  const addItem = (title: string) => {
    const newTask = new Task('', title)
    setList([...list, newTask])
    newTask.create()
  }

  const renderHiddenItem = (data, rowMap) => (
    <View style={styles.rowBack}>
      <Text>Left</Text>
      <TouchableOpacity
        style={[styles.backRightBtn, styles.backRightBtnLeft]}
        onPress={() => closeRow(rowMap, data.item.key)}
      >
        <Text style={styles.backTextWhite}>Close</Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={[styles.backRightBtn, styles.backRightBtnRight]}
        onPress={() => deleteRow(rowMap, data.item)}
      >
        <Text style={styles.backTextWhite}>Delete</Text>
      </TouchableOpacity>
    </View>
  )

  const closeRow = (rowMap, rowKey) => {
    if (rowMap[rowKey]) {
      rowMap[rowKey].closeRow()
    }
  }

  const deleteRow = (rowMap, task: Task) => {
    closeRow(rowMap, task.key)
    setList(list.filter((t) => t !== task))
    task.delete()
  }

  const onRowDidOpen = (rowKey) => {
    console.log('This row opened', rowKey)
  }

  return (
    <NativeBaseProvider>
      <Center flex={1}>
        <VStack space={4} flex={1} w="90%" mt={4}>
          <Input
            variant="filled"
            InputRightElement={
              <IconButton
                icon={<Icon as={FontAwesome5} name="plus" size={4} />}
                colorScheme="emerald"
                ml={1}
                onPress={() => {
                  addItem(inputValue)
                  setInputValue('')
                }}
                mr={1}
              />
            }
            onChangeText={(v) => setInputValue(v)}
            value={inputValue}
            placeholder="Add Item"
          />
          <VStack>
            <SwapableList listData={list} onRowDidOpen={onRowDidOpen} renderHiddenItem={renderHiddenItem} />
          </VStack>
        </VStack>
      </Center>
    </NativeBaseProvider>
  )
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: 'white',
    flex: 1,
  },
  backTextWhite: {
    color: '#FFF',
  },
  rowFront: {
    alignItems: 'center',
    backgroundColor: '#CCC',
    borderBottomColor: 'black',
    borderBottomWidth: 1,
    justifyContent: 'center',
    height: 50,
  },
  rowBack: {
    alignItems: 'center',
    backgroundColor: '#DDD',
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingLeft: 15,
  },
  backRightBtn: {
    alignItems: 'center',
    bottom: 0,
    justifyContent: 'center',
    position: 'absolute',
    top: 0,
    width: 75,
  },
  backRightBtnLeft: {
    backgroundColor: 'blue',
    right: 75,
  },
  backRightBtnRight: {
    backgroundColor: 'red',
    right: 0,
  },
})
