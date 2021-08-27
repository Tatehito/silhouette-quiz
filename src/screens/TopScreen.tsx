import { FontAwesome5, AntDesign } from '@expo/vector-icons'
import {
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
  Select,
  CheckIcon,
} from 'native-base'
import React, { useState, useEffect } from 'react'
import { StyleSheet, Text, TouchableHighlight, TouchableOpacity, View } from 'react-native'
import { SwipeListView } from 'react-native-swipe-list-view'

import Task from '../entity/Task'
import useAllCategories from '../hooks/useAllCategories'

export default function () {
  const [showModal, setShowModal] = useState(false)
  const [list, setList] = useState<Task[]>()
  const [inputValue, setInputValue] = useState('')
  const [selectedCategoryId, setSelectedCategoryId] = useState('')

  const allCategories = useAllCategories()

  const categoryOptions = allCategories.map((category) => <Select.Item label={category.name} value={category.id} />)

  useEffect(() => {
    Task.getAll()
      .then((tasks) => {
        setList(tasks)
      })
      .catch((error) => {
        console.error(error)
      })
  }, [])

  const addItem = () => {
    const newTask = new Task('', inputValue, selectedCategoryId)
    setList([...list, newTask])
    newTask.create()
  }

  const handleAddTaskButton = () => {
    if (inputValue) {
      addItem()
      setInputValue('')
      setShowModal(false)
    }
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
        <Text style={SwipableStyles.text}>{data.item.categoryId}</Text>
      </View>
    </TouchableHighlight>
  )

  return (
    <NativeBaseProvider>
      <Center flex={1}>
        <VStack space={4} flex={1} w="90%" mt={4}>
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
            <Modal.Header>タスクを追加する</Modal.Header>
            <Modal.Body>
              <Input
                variant="filled"
                InputRightElement={
                  <IconButton
                    icon={<Icon as={FontAwesome5} name="plus" size={4} />}
                    ml={1}
                    onPress={() => {
                      handleAddTaskButton()
                    }}
                    mr={1}
                  />
                }
                onChangeText={(v) => setInputValue(v)}
                value={inputValue}
                placeholder="Add Item"
              />
              <Select
                selectedValue={selectedCategoryId}
                minWidth={200}
                accessibilityLabel="Select your favorite programming language"
                placeholder="カテゴリ"
                onValueChange={(itemValue) => setSelectedCategoryId(itemValue)}
                _selectedItem={{
                  bg: 'cyan.600',
                  endIcon: <CheckIcon size={4} />,
                }}
              >
                <Select.Item label="" value="" />
                {categoryOptions}
              </Select>
            </Modal.Body>
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
