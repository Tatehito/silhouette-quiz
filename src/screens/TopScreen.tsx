import { FontAwesome5, AntDesign } from '@expo/vector-icons'
import {
  Button,
  Input,
  Checkbox,
  IconButton,
  VStack,
  Icon,
  Center,
  NativeBaseProvider,
  Box,
  Fab,
  Modal,
} from 'native-base'
import React, { useState } from 'react'
import { StyleSheet, Text, TouchableHighlight, TouchableOpacity, View } from 'react-native'
import { SwipeListView } from 'react-native-swipe-list-view'

import Task from '../entity/Task'

export default function () {
  const [showModal, setShowModal] = useState(false)
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

  const renderItem = (data) => (
    <TouchableHighlight style={SwipableStyles.rowFront} underlayColor="#AAA">
      <View style={{ flexDirection: 'row' }}>
        <Checkbox value="" />
        <Text style={SwipableStyles.text}>{data.item.name}</Text>
      </View>
    </TouchableHighlight>
  )

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
            <View>
              <SwipeListView
                data={list}
                renderItem={renderItem}
                renderHiddenItem={renderHiddenItem}
                leftOpenValue={75}
                rightOpenValue={-150}
                previewRowKey={'0'}
                previewOpenValue={-40}
                previewOpenDelay={3000}
                onRowDidOpen={onRowDidOpen}
              />
            </View>
          </VStack>
        </VStack>
      </Center>

      <Center flex={1}>
        <Box position="relative" h={100} w="100%">
          <Fab
            onPress={() => setShowModal(true)}
            position="absolute"
            size="sm"
            icon={<Icon color="white" as={<AntDesign name="plus" />} size="sm" />}
          />
        </Box>
      </Center>

      <Center flex={1}>
        <Modal isOpen={showModal} onClose={() => setShowModal(false)}>
          <Modal.Content maxWidth="400px">
            <Modal.CloseButton />
            <Modal.Header>Modal Title</Modal.Header>
            <Modal.Body>
              eiusmod sunt ex incididunt cillum quis. Velit duis sit officia eiusmod Lorem aliqua enim
            </Modal.Body>
            <Modal.Footer>
              <Button.Group variant="ghost" space={2}>
                <Button>LEARN MORE</Button>
                <Button
                  onPress={() => {
                    setShowModal(false)
                  }}
                >
                  ACCEPT
                </Button>
              </Button.Group>
            </Modal.Footer>
          </Modal.Content>
        </Modal>
      </Center>
    </NativeBaseProvider>
  )
}

const SwipableStyles = StyleSheet.create({
  rowFront: {
    backgroundColor: '#fff',
    borderBottomColor: 'black',
    justifyContent: 'center',
    height: 50,
    paddingLeft: 30,
  },
  text: {
    marginLeft: 10,
  },
})

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
