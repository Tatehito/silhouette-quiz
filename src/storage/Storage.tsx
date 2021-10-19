import AsyncStorage from '@react-native-async-storage/async-storage'
import Storage from 'react-native-storage'

const storage: Storage = new Storage({
  // 最大容量
  // 最適な値が分からない
  size: 1000,
  // バックエンドにAsyncStorageを使う
  storageBackend: AsyncStorage,
  // キャッシュ期限(null=期限なし)
  defaultExpires: null,
  // メモリにキャッシュするかどうか
  enableCache: true,
})

export default storage
