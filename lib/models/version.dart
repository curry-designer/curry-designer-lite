class Version {
  final int id;
  final int recipeId;
  final String latestUpdateDate;
  final int starCount;
  final String comment;

  // Constructor.
  Version(
      {this.id,
      this.recipeId,
      this.latestUpdateDate,
      this.starCount,
      this.comment});

  int get getRecipeId => recipeId;
  String get getLatestUpdateDate => latestUpdateDate;
  int get getId => id;
  int get getStarCount => starCount;
  String get getComment => comment;

  factory Version.fromDatabaseJson(Map<String, dynamic> data) => Version(
        id: data['id'],
        recipeId: data['recipe_id'],
        latestUpdateDate: data['latest_update_date'],
        starCount: data['star_count'],
        comment: data['comment'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "recipe_id": this.recipeId,
        "latest_update_date": this.latestUpdateDate,
        "star_count": this.starCount,
        "comment": this.comment,
      };
}
