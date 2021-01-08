abstract class JsonDaoEngine {
  /// Returns all objects
  Future<Map<String, Map<String, dynamic>>> readAll();

  Future<Map<String, dynamic>> read(String id);

  /// Returns [id] of saved [object]
  Future<String> save(Map<String, dynamic> object);

  Future<void> update(String id, Map<String, dynamic> object);

  Future<void> delete(String id);
}
