import 'package:currydesignerlite/stores/version_filter_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/enums/version_sort_key.dart';
import '../common/widget/labeled_radio.dart';

class VersionFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _VersionFilter();
  }
}

class _VersionFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 入力キーボードをどこを押しても閉じれるようにするための現在のフォーカスを定義。
    final currentFocus = FocusScope.of(context);
    // デフォルトのソートキー
    final _sort =
        context.select((VersionFilterStore store) => store.getSortKey);
    final _star =
        context.select((VersionFilterStore store) => store.getStarCount);
    // 入力キーボードを使用の際に全体のBottomをあげる。入力キーボードでフォームが隠れてしまうため。
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      // 入力キーボードをどこを押しても閉じれるようにする。
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: SingleChildScrollView(
          reverse: context
              .select((VersionFilterStore store) => store.getReverseFlag),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomSpace),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: const Text(
                    '並び順',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                LabeledRadio(
                  label: 'バージョン順',
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  value: VersionSortKeyEnum.VERSION,
                  groupValue: _sort,
                  onChanged: (VersionSortKeyEnum value) => {
                    _setSortKey(
                      context,
                      value,
                    ),
                  },
                ),
                LabeledRadio(
                  label: 'スター順',
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  value: VersionSortKeyEnum.STAR_COUNT,
                  groupValue: _sort,
                  onChanged: (VersionSortKeyEnum value) => {
                    _setSortKey(
                      context,
                      value,
                    ),
                  },
                ),
                LabeledRadio(
                  label: '更新日時順',
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  value: VersionSortKeyEnum.UPDATED_DATE_TIME,
                  groupValue: _sort,
                  onChanged: (VersionSortKeyEnum value) => {
                    _setSortKey(
                      context,
                      value,
                    ),
                  },
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: const Text(
                    '絞り込み',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    context.read<VersionFilterStore>().getOpenStarCountFlag
                        ? context
                            .read<VersionFilterStore>()
                            .changeOpenStarCountFlagFalse()
                        : context
                            .read<VersionFilterStore>()
                            .changeOpenStarCountFlagTrue();
                  },
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'スターの数で絞り込み',
                          style: TextStyle(fontSize: 16),
                        ),
                        context.select((VersionFilterStore store) =>
                                store.getOpenStarCountFlag)
                            ? const Icon(Icons.arrow_drop_up_outlined)
                            : const Icon(Icons.arrow_drop_down_outlined)
                      ],
                    ),
                  ),
                ),
                Container(
                  child: !context.select((VersionFilterStore store) =>
                          store.getOpenStarCountFlag)
                      ? null
                      : Column(
                          children: [
                            LabeledRadio(
                              label: '0',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              value: 0,
                              groupValue: _star,
                              onChanged: (int value) => {
                                _setStarCount(
                                  context,
                                  value,
                                ),
                              },
                            ),
                            LabeledRadio(
                              label: '1',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              value: 1,
                              groupValue: _star,
                              onChanged: (int value) => {
                                _setStarCount(
                                  context,
                                  value,
                                ),
                              },
                            ),
                            LabeledRadio(
                              label: '2',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              value: 2,
                              groupValue: _star,
                              onChanged: (int value) => {
                                _setStarCount(
                                  context,
                                  value,
                                ),
                              },
                            ),
                            LabeledRadio(
                              label: '3',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              value: 3,
                              groupValue: _star,
                              onChanged: (int value) => {
                                _setStarCount(
                                  context,
                                  value,
                                ),
                              },
                            ),
                            LabeledRadio(
                              label: '4',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              value: 4,
                              groupValue: _star,
                              onChanged: (int value) => {
                                _setStarCount(
                                  context,
                                  value,
                                ),
                              },
                            ),
                            LabeledRadio(
                              label: '5',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              value: 5,
                              groupValue: _star,
                              onChanged: (int value) => {
                                _setStarCount(
                                  context,
                                  value,
                                ),
                              },
                            ),
                          ],
                        ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    context.read<VersionFilterStore>().getOpenFreeWordFlag
                        ? context
                            .read<VersionFilterStore>()
                            .changeOpenFreeWordFlagFalse()
                        : context
                            .read<VersionFilterStore>()
                            .changeOpenFreeWordFlagTrue();
                  },
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'フリーワードで絞り込み',
                          style: TextStyle(fontSize: 16),
                        ),
                        context.select((VersionFilterStore store) =>
                                store.getOpenFreeWordFlag)
                            ? const Icon(Icons.arrow_drop_up_outlined)
                            : const Icon(Icons.arrow_drop_down_outlined)
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: !context.select((VersionFilterStore store) =>
                          store.getOpenFreeWordFlag)
                      ? null
                      : TextFormField(
                          maxLength: 100,
                          decoration: const InputDecoration(
                            hintText: '中辛 etc...',
                          ),
                          validator: (String value) {
                            return value.isEmpty ? 'レシピ名を入力してください。' : null;
                          },
                          onChanged: (String value) {
                            context
                                .read<VersionFilterStore>()
                                .setFreeWord(value);
                          },
                          onTap: () => {
                            context
                                .read<VersionFilterStore>()
                                .changeReverseFlagTrue()
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setSortKey(BuildContext context, VersionSortKeyEnum sortKey) {
    context.read<VersionFilterStore>().setSortKey(sortKey);
  }

  void _setStarCount(BuildContext context, int starCount) {
    context.read<VersionFilterStore>().setStarCount(starCount);
  }
}
