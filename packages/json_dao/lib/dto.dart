class Dto<Model> {
  final String id;
  final Model data;

  const Dto(this.id, this.data);

  @override
  String toString() {
    // ignore: prefer_interpolation_to_compose_strings
    return 'Dto(' + {'id': id, 'data': data}.toString() + ')';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Dto<Model> && o.id == id && o.data == data;
  }

  @override
  int get hashCode => id.hashCode ^ data.hashCode;
}
