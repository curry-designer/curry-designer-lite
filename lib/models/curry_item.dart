import "./curry_item_action_enum.dart";

class CurryItem {
  final int id;
  final String name;
  final String latestVersion;
  final int starCount;

  // Constructor.
  CurryItem({this.id, this.name, this.latestVersion, this.starCount});

  String get getName => name;
  String get getLatestVersion => latestVersion;
  int get getId => id;
  int get getStarCount => starCount;

  factory CurryItem.fromDatabaseJson(Map<String, dynamic> data) => CurryItem(
        id: data['id'],
        name: data['name'],
        latestVersion: data['latest_version'],
        starCount: data['star_count'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "name": this.name,
        "latest_version": this.latestVersion,
        "star_count": this.starCount,
      };
}
