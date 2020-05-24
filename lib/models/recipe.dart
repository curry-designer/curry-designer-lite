class Recipe {
  final int id;
  final String name;
  final String latestUpdateDate;

  // Constructor.
  Recipe({this.id, this.name, this.latestUpdateDate});

  String get getName => name;
  String get getLatestUpdateDate => latestUpdateDate;
  int get getId => id;

  factory Recipe.fromDatabaseJson(Map<String, dynamic> data) => Recipe(
        id: data['id'],
        name: data['name'],
        latestUpdateDate: data['latest_update_date'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "name": this.name,
        "latest_update_date": this.latestUpdateDate,
      };
}
