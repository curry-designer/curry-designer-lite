class Version {
  // Constructor.
  Version(
      {this.id, this.recipeId, this.updateDate, this.starCount, this.comment});

  factory Version.fromDatabaseJson(Map<String, dynamic> data) => Version(
        id: data['id'] as int,
        recipeId: data['recipe_id'] as int,
        updateDate: data['update_date'] as String,
        starCount: data['star_count'] as int,
        comment: data['comment'] as String,
      );

  final int id;
  final int recipeId;
  final String updateDate;
  final int starCount;
  final String comment;

  // Getter.
  int get getRecipeId => recipeId;
  String get getLatestUpdateDate => updateDate;
  int get getId => id;
  int get getStarCount => starCount;
  String get getComment => comment;
}
