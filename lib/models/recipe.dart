class Recipe {
  // Constructor.
  Recipe(
      {this.id,
      this.name,
      this.latestUpdateDate,
      this.starCount,
      this.maxVersion});

  factory Recipe.fromDatabaseJson(Map<String, dynamic> data) => Recipe(
        id: data['id'] as int,
        name: data['name'] as String,
        latestUpdateDate: data['latest_update_date'] as String,
        starCount: data['star_count'] as int,
        maxVersion: data['max_version'] as int,
      );

  final int id;
  final String name;
  final String latestUpdateDate;
  final int starCount;
  final int maxVersion;

  // Getter.
  String get getName => name;
  String get getLatestUpdateDate => latestUpdateDate.substring(0, 10);
  int get getId => id;
  int get getStarCount => starCount;
  int get getMaxVersion => maxVersion;
}
