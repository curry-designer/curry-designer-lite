class Version {
  // Constructor.
  Version(
      {this.id,
      this.recipeId,
      this.updateDateTime,
      this.starCount,
      this.comment});

  factory Version.fromDatabaseJson(Map<String, dynamic> data) => Version(
        id: data['id'] as int,
        recipeId: data['recipe_id'] as int,
        updateDateTime: data['updated_date_time'] as String,
        starCount: data['star_count'] as int,
        comment: data['comment'] as String,
      );

  final int id;
  final int recipeId;
  final String updateDateTime;
  final int starCount;
  final String comment;

  // Getter.
  int get getRecipeId => recipeId;
  String get getLatestUpdateDateTime => updateDateTime;
  int get getId => id;
  int get getStarCount => starCount;
  String get getComment => comment;
}
