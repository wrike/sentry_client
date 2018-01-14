
Map<K, V> cleanNulls<K, V>(Map<K, V> map) {
  final resultMap = <K, V>{};
  map.forEach((K key, V value) {
    if (value != null) {
      resultMap[key] = value;
    }
  });
  return resultMap;
}
