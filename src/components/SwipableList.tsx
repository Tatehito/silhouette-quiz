import { MaterialIcons } from '@expo/vector-icons'
import React from 'react'
import { StyleSheet, Text, TouchableOpacity, TouchableHighlight, View } from 'react-native'
import { SwipeListView } from 'react-native-swipe-list-view'

import useDeleteQuestion from '../hooks/useDeleteQuestion'

export default function ({ dataList, setDataList, handleClickItem }) {
  const deleteQuestion = useDeleteQuestion()

  const closeRow = (rowMap, rowKey) => {
    if (rowMap[rowKey]) {
      rowMap[rowKey].closeRow()
    }
  }

  const deleteRow = (data, rowMap, rowKey) => {
    deleteQuestion(data.item)
    closeRow(rowMap, rowKey)
    const newData = [...dataList]
    const prevIndex = dataList.findIndex((item) => item.id === rowKey)
    newData.splice(prevIndex, 1)
    setDataList(newData)
  }

  const renderItem = (data) => (
    <TouchableHighlight onPress={() => handleClickItem(data.item)} style={styles.rowFront} underlayColor={'#AAA'}>
      <View>
        <Text style={styles.rowFrontText}>{data.item.name}</Text>
      </View>
    </TouchableHighlight>
  )

  const renderHiddenItem = (data, rowMap) => (
    <View style={styles.rowBack}>
      <TouchableOpacity
        style={[styles.backRightBtn, styles.backRightBtnRight]}
        onPress={() => deleteRow(data, rowMap, data.item.id)}
      >
        <MaterialIcons name="delete" style={styles.deleteIcon} />
      </TouchableOpacity>
    </View>
  )

  return (
    <View style={styles.container}>
      <SwipeListView
        data={dataList}
        renderItem={renderItem}
        renderHiddenItem={renderHiddenItem}
        leftOpenValue={0}
        rightOpenValue={-75}
        previewRowKey={'0'}
        previewOpenValue={-40}
        previewOpenDelay={3000}
      />
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    height: '100%',
    backgroundColor: '#fff',
  },
  rowFront: {
    backgroundColor: '#fff',
    borderBottomColor: '#E8E8E8',
    borderBottomWidth: 1,
    justifyContent: 'center',
    height: 50,
    marginLeft: 20,
    paddingLeft: 20,
    fontSize: 100,
  },
  rowFrontText: {
    fontSize: 16,
    fontWeight: '700',
  },
  rowBack: {
    backgroundColor: '#fff',
    flex: 1,
  },
  backRightBtn: {
    alignItems: 'center',
    bottom: 0,
    justifyContent: 'center',
    position: 'absolute',
    top: 0,
    width: 75,
  },
  backRightBtnRight: {
    backgroundColor: 'red',
    right: 0,
  },
  deleteIcon: {
    color: '#ffffff',
    fontSize: 30,
  },
})
