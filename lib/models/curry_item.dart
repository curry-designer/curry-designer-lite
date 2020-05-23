import "./curry_item_action_enum.dart";

class CurryItem {
  final int id;
  final String name;
  final String latestUpdateDate;
  final int starCount;

  // Constructor.
  CurryItem({this.id, this.name, this.latestUpdateDate, this.starCount});

  String get getName => name;
  String get getLatestUpdateDate => latestUpdateDate;
  int get getId => id;
  int get getStarCount => starCount;

  factory CurryItem.fromDatabaseJson(Map<String, dynamic> data) => CurryItem(
        id: data['id'],
        name: data['name'],
        latestUpdateDate: data['latest_update_date'],
        starCount: data['star_count'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "name": this.name,
        "latest_update_date": this.latestUpdateDate,
        "star_count": this.starCount,
      };
}
