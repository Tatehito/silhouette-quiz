import * as FileSystem from 'expo-file-system'
import * as ImagePicker from 'expo-image-picker'
import React, { useState, useEffect } from 'react'
import { Button, Image, View, Platform, Text } from 'react-native'

export default function () {
  const directory = FileSystem.cacheDirectory + 'foo/'

  const [images, setImages] = useState([''])

  async function createDirectory() {
    const dirInfo = await FileSystem.getInfoAsync(directory)
    if (!dirInfo.exists) {
      await FileSystem.makeDirectoryAsync(directory, { intermediates: true })
    }
  }

  useEffect(() => {
    ;(async () => {
      if (Platform.OS !== 'web') {
        const { status } = await ImagePicker.requestMediaLibraryPermissionsAsync()
        if (status !== 'granted') {
          alert('Sorry, we need camera roll permissions to make this work!')
        }

        createDirectory()
      }
    })()
  }, [])

  const pickImage = async () => {
    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.All,
      allowsEditing: true,
      aspect: [4, 3],
      quality: 1,
    })

    if (!result.cancelled) {
      const to = directory + `'img_'${images.length}`
      await FileSystem.copyAsync({
        from: result.uri,
        to,
      })
      setImages([...images, to])
    }
  }

  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Button title="Pick an image from camera roll" onPress={pickImage} />
      {images.map((image) => (
        <Image source={{ uri: image }} style={{ width: 200, height: 200 }} />
      ))}
    </View>
  )
}
