abstract class Mapper<Model> {
  Map<String, dynamic> toMap(Model model);

  Model fromMap(Map<String, dynamic> map);
}
