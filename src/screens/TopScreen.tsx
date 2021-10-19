import { Center, NativeBaseProvider } from 'native-base'
import React, { useState, useEffect } from 'react'
import { StyleSheet, Text, TouchableHighlight, TouchableOpacity, View, Button } from 'react-native'
import { SwipeListView } from 'react-native-swipe-list-view'
import storage from '../storage/Storage'

export default function ({ navigation }) {
  const [list, setList] = useState<Task[]>()

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

  const handleClickQuiz = () => {
    navigation.navigate('QuestionCreate')
  }

  const handleClickStartQuizButton = () => {
    storage
      .load({
        key: 'name',
      })
      .then((data) => {
        console.log(data)
      })
  }

  const renderHiddenItem = (data, rowMap) => (
    <View style={styles.rowBack}>
      <TouchableOpacity
        style={[styles.backRightBtn, styles.backRightBtnRight]}
        onPress={() => deleteRow(rowMap, data.item)}
      >
        <Text style={styles.backTextWhite}>Delete</Text>
      </TouchableOpacity>
    </View>
  )

  const renderItem = (data) => (
    <TouchableHighlight style={SwipableStyles.rowFront} underlayColor="#AAA">
      <View style={{ flexDirection: 'row' }}>
        <Text style={SwipableStyles.text}>{data.item.name}</Text>
        <Text style={SwipableStyles.text}>{data.item.categoryId}</Text>
      </View>
    </TouchableHighlight>
  )

  return (
    <NativeBaseProvider>
      <View>
        <Text onPress={handleClickQuiz}>＋もんだいをつくる</Text>
      </View>

      <Center flex={1}>
        <View>
          <SwipeListView
            data={list}
            renderItem={renderItem}
            renderHiddenItem={renderHiddenItem}
            rightOpenValue={-75}
            previewRowKey={'0'}
            previewOpenValue={-40}
            previewOpenDelay={3000}
          />
        </View>
      </Center>

      <Center flex={1}>
        <Button onPress={handleClickStartQuizButton} title="クイズをはじめる" />
      </Center>
      <Center flex={1}>
        <Text onPress={handleClickQuiz}>＋もんだいをつくる</Text>
      </Center>
    </NativeBaseProvider>
  )
}

const SwipableStyles = StyleSheet.create({
  rowFront: {
    backgroundColor: '#fff',
    borderBottomColor: 'red',
    borderBottomWidth: 1,
    justifyContent: 'center',
    height: 50,
    paddingLeft: 5,
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
