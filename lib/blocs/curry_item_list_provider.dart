import 'package:flutter/widgets.dart';
import './curry_item_list_bloc.dart';

class CurryItemListProvider extends InheritedWidget {
  final CurryItemListBloc bloc;

  // Constructor.
  CurryItemListProvider({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  static CurryItemListBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CurryItemListProvider)
            as CurryItemListProvider)
        .bloc;
  }

  @override
  bool updateShouldNotify(CurryItemListProvider oldWidget) =>
      bloc != oldWidget.bloc;
}
