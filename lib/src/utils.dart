
Map<K, V> cleanEmpties<K, V>(Map<K, V> map) {
  final resultMap = <K, V>{};
  map.forEach((K key, V value) {
    if (value == null) {
      return null;
    }
    if (value is Map && value.isEmpty) {
      return null;
    }
    if (value is Iterable && value.isEmpty) {
      return null;
    }

    resultMap[key] = value;
  });
  return resultMap;
}
