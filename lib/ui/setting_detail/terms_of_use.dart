import 'package:flutter/material.dart';

class TermsOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TermsOfUse(); // This tra
  }
}

class _TermsOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('利用規約'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '利用規約',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '第1条（本利用規約について)',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '1. アプリ利用規約（以下「本利用規約」といいます。）は、Tanoshige（以下「当社」といいます。）が本アプリ上で提供するサービスを、ユーザーが利用する際の一切の行為に適用されます。\n\n'
                    '2. 本利用規約は、本サービスの利用条件を定めるものです。ユーザーは、本利用規約に従い本サービスを利用するものとします。\n\n'
                    '3. ユーザーは、本アプリをダウンロードした場合、本利用規約の全ての記載内容について同意したものとみなされます。\n\n'
                    '4. 変更後の利用規約は、当社が別途定める場合を除いて、本アプリ上に表示した時点より効力を生じるものとします。\n\n'
                    '5. ユーザーが、変更後の本利用規約に同意できない場合は、直ちに本アプリをユーザー自身のスマートフォン等の携帯端末（以下、「携帯端末」といいます）から削除するものとします。',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '第2条（利用条件等）',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '1. ユーザーは、自己の責任において本アプリをユーザー自身のスマートフォン等の携帯端末にダウンロードし、インストールするものとします。なお、本アプリが全ての携帯端末に対応することを保証するものではありません。\n\n'
                    '2. ユーザーは、本アプリのダウンロードを完了し、その利用を開始することが可能になった時点から本アプリを利用することができます。なお、本アプリは、当該携帯端末のみにダウンロードおよびインストールできるものとします。\n\n'
                    '3. 本アプリの著作権・その他の権利は、当社に帰属します。本規約は、明示的に定めがある場合を除き、ユーザーに本アプリの著作権その他いかなる権利も移転することを許諾するものではありません。',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '第3条（本サービスの提供の停止等）',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '当社は、ユーザーの承諾およびユーザーへの通知なしに、いつでも本サービスまたは本アプリ提供の一時休止または終了、本サービスの内容変更および本アプリの改変等を行うことができるものとします。',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '第4条（免責）',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '本アプリは現状有姿で提供されます。当社は、本アプリの完全性、有用性、動作保証、特定の目的への適合性、使用機器への適合性その他一切の事項について保証しません。また、通信障害、システム機器等の瑕疵、障害又は本アプリの利用により利用者又は第三者が被った損害について、提供者は一切の責任を負いません。 利用者の操作により、本アプリが、他のアプリを呼び出す場合又は他のアプリの機能を利用する場合、当該アプリの仕様、動作及び効果等について、提供者は一切の責任を負いません。\n\n'
                    '当社は，本サービスの提供の停止または中断により，ユーザーまたは第三者が被ったいかなる不利益または損害についても，一切の責任を負わないものとします。',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '第5条（利用規約の変更）',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: const Text(
                    '当社は，必要と判断した場合には，ユーザーに通知することなくいつでも本規約を変更することができるものとします。なお，本規約の変更後，本サービスの利用を開始した場合には，当該ユーザーは変更後の規約に同意したものとみなします。',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
