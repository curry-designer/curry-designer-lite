import "./curry_item_action_enum.dart";

class CurryItem {
  final String name;
  final int latestVersion;
  final CurryItemActionEnum curryItemAction;

  // Constructor.
  CurryItem(this.name, this.latestVersion, this.curryItemAction);

  String get getName => name;
  int get getLatestVersion => latestVersion;
  CurryItemActionEnum get getCurryItemAction => curryItemAction;
}
