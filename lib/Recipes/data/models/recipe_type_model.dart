class RecipeTypeModel {
  final int id;
  final String name;

  RecipeTypeModel({required this.id, required this.name});

  factory RecipeTypeModel.fromJson(Map<String, dynamic> json) {
    return RecipeTypeModel(
      id: json["id"],
      name: json["name"],
    );
  }
}
