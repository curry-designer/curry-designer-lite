class Recipe {
  final int id;
  final String name;
  final String latestUpdateDate;
  final int starCount;
  final int maxVersion;

  // Constructor.
  Recipe(
      {this.id,
      this.name,
      this.latestUpdateDate,
      this.starCount,
      this.maxVersion});

  String get getName => name;
  String get getLatestUpdateDate => latestUpdateDate;
  int get getId => id;
  int get getStarCount => starCount;
  int get getMaxVersion => maxVersion;

  factory Recipe.fromDatabaseJson(Map<String, dynamic> data) => Recipe(
      id: data['id'],
      name: data['name'],
      latestUpdateDate: data['latest_update_date'],
      starCount: data['star_count'],
      maxVersion: data['max_version']);

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "name": this.name,
        "latest_update_date": this.latestUpdateDate,
        "star_count": this.starCount,
        "max_version": this.maxVersion,
      };
}
