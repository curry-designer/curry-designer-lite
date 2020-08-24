class HowToMake {
  final int id;
  final int recipeId;
  final int versionId;
  final String howToMake;
  final int orderHowToMake;

  // Constructor.
  HowToMake(
      {this.id,
      this.recipeId,
      this.versionId,
      this.howToMake,
      this.orderHowToMake});

  // Getter.
  int get getId => id;
  int get getRecipeId => recipeId;
  int get getVersionId => versionId;
  String get getHowToMake => howToMake;
  int get getOrderHowToMake => orderHowToMake;

  factory HowToMake.fromDatabaseJson(Map<String, dynamic> data) => HowToMake(
      id: data['id'],
      recipeId: data['recipe_id'],
      versionId: data['version_id'],
      howToMake: data['how_to_make'],
      orderHowToMake: data['order_how_to_make']);

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "recipe_id": this.recipeId,
        "version_id": this.versionId,
        "how_to_make": this.howToMake,
        "order_how_to_make": this.orderHowToMake,
      };
}
