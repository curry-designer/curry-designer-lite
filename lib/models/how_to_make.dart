class HowToMake {
  // Constructor.
  HowToMake(
      {this.id,
      this.recipeId,
      this.versionId,
      this.howToMake,
      this.orderHowToMake});

  factory HowToMake.fromDatabaseJson(Map<String, dynamic> data) => HowToMake(
        id: data['id'] as int,
        recipeId: data['recipe_id'] as int,
        versionId: data['version_id'] as int,
        howToMake: data['how_to_make'] as String,
        orderHowToMake: data['order_how_to_make'] as int,
      );

  final int id;
  final int recipeId;
  final int versionId;
  final String howToMake;
  final int orderHowToMake;

  // Getter.
  int get getId => id;
  int get getRecipeId => recipeId;
  int get getVersionId => versionId;
  String get getHowToMake => howToMake;
  int get getOrderHowToMake => orderHowToMake;
}
