class CategoryModel {
  String name = '';
  String emoji = '';
  double budget = 0.0;

  CategoryModel({required this.name, required this.emoji, this.budget = 0.0});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    emoji = json['emoji'] ?? '';
    budget = (json['budget'] ?? 0.0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['emoji'] = emoji;
    data['budget'] = budget;
    return data;
  }
}
