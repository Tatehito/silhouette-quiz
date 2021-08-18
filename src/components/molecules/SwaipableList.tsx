import { Checkbox } from 'native-base'
import React from 'react'
import { StyleSheet, Text, TouchableHighlight, View } from 'react-native'
import { SwipeListView } from 'react-native-swipe-list-view'

export default function SwaipableList(props) {
  const renderItem = (data) => (
    <TouchableHighlight style={styles.rowFront} underlayColor="#AAA">
      <View style={{ flexDirection: 'row' }}>
        <Checkbox value="" />
        <Text style={styles.text}>{data.item.text}</Text>
      </View>
    </TouchableHighlight>
  )

  return (
    <View>
      <SwipeListView
        data={props.listData}
        renderItem={renderItem}
        renderHiddenItem={props.renderHiddenItem}
        leftOpenValue={75}
        rightOpenValue={-150}
        previewRowKey={'0'}
        previewOpenValue={-40}
        previewOpenDelay={3000}
        onRowDidOpen={props.onRowDidOpen}
      />
    </View>
  )
}

const styles = StyleSheet.create({
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
