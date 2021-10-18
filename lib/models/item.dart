class Item {
  late final String title;
  late bool done;

  Item({required this.title, required this.done});

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['done'] = done;
    return _data;
  }
}
