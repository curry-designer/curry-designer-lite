class Version {
  final int id;
  final int recipeId;
  final String updateDate;
  final int starCount;
  final String comment;

  // Constructor.
  Version(
      {this.id, this.recipeId, this.updateDate, this.starCount, this.comment});

  // Getter.
  int get getRecipeId => recipeId;
  String get getLatestUpdateDate => updateDate;
  int get getId => id;
  int get getStarCount => starCount;
  String get getComment => comment;

  factory Version.fromDatabaseJson(Map<String, dynamic> data) => Version(
        id: data['id'],
        recipeId: data['recipe_id'],
        updateDate: data['update_date'],
        starCount: data['star_count'],
        comment: data['comment'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "recipe_id": this.recipeId,
        "latest_update_date": this.updateDate,
        "star_count": this.starCount,
        "comment": this.comment,
      };
}
