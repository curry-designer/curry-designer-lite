import "./curry_item_action_enum.dart";

class CurryItem {
  final int id;
  final String name;
  final String latestVersion;

  // Constructor.
  CurryItem({this.id, this.name, this.latestVersion});

  String get getName => name;
  String get getLatestVersion => latestVersion;
  int get getId => id;

  factory CurryItem.fromDatabaseJson(Map<String, dynamic> data) => CurryItem(
        id: data['id'],
        name: data['name'],
        latestVersion: data['latest_version'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "name": this.name,
        "latest_version": this.latestVersion,
      };
}
