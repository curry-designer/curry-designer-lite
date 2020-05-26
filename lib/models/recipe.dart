class Recipe {
  final int id;
  final String name;
  final String latestUpdateDate;
  final int starCount;

  // Constructor.
  Recipe({this.id, this.name, this.latestUpdateDate, this.starCount});

  String get getName => name;
  String get getLatestUpdateDate => latestUpdateDate;
  int get getId => id;
  int get getStarCount => starCount;

  factory Recipe.fromDatabaseJson(Map<String, dynamic> data) => Recipe(
      id: data['id'],
      name: data['name'],
      latestUpdateDate: data['latest_update_date'],
      starCount: data['star_count']);

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "name": this.name,
        "latest_update_date": this.latestUpdateDate,
        "star_count": this.starCount,
      };
}
