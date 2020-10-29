import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/homeroom/show/index.dart';
import 'package:lecture_performance_app/common/Header.dart';
import 'package:lecture_performance_app/db/models/homeroom.dart';
import 'package:lecture_performance_app/providers/homeroom_provider.dart';
import 'package:provider/provider.dart';

class HomeroomIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'クラス一覧'),
      body: Consumer<HomeRoomProvider>(
        builder: (context, counter, _) {
          return Center(
            child: HomeRoomList(),
          );
        },
      ),
      floatingActionButton: _FloatingActionButton(context),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton(
    this.context, {
    Key key,
  }) : super(key: key);

  final BuildContext context;

  void _routing() {
    Navigator.pushNamed(context, '/home/regist');
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _routing,
      tooltip: 'Increment',
      label: const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'クラス登録',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: Colors.blueAccent,
    );
  }
}

class HomeRoomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return ListView.builder(
      itemBuilder: (context, int index) {
        return Center(
          child: Container(
            width: 800,
            child: Center(child: _ListCard(homeRoomProvider.list[index])),
          ),
        );
      },
      itemCount: homeRoomProvider.list.length,
    );
  }
}

@immutable
class _ListCard extends StatelessWidget {
  const _ListCard(this.homeroom);
  final HomeRoom homeroom;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          HomeroomShow.routeName,
          arguments: HomeroomShowArgument(
            homeroom,
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
                size: 40,
              ),
              onPressed: () {
                editPopup(context, homeroom.id);
              },
            ),
            title: Text(
              '${homeroom.grade}年${homeroom.lectureClass}組',
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> editPopup(
  BuildContext context,
  int id,
) async {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: Container(
          height: 400,
          child: Column(
            children: [
              InkWell(
                child: const MenuItem(
                  text: '編集する',
                  icon: Icons.edit,
                ),
                onTap: () {
                  Navigator.pop(context);
                  editAlertPopUp(context, id);
                },
              ),
              InkWell(
                child: const MenuItem(
                  text: '削除する',
                  icon: Icons.delete,
                ),
                onTap: () {
                  Navigator.pop(context);
                  deleteAlertPopUp(context, id);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key key,
    @required this.text,
    @required this.icon,
  }) : super(key: key);

  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: IconButton(
            icon: Icon(
              icon,
              color: Colors.redAccent,
              size: 40,
            ),
            onPressed: () {},
          ),
          title: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> deleteAlertPopUp(
  BuildContext context,
  int id,
) async {
  final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text(
          'このクラスを削除',
          style: TextStyle(fontSize: 32),
        ),
        content: const Text(
          'この動作は一度行うと取り消すことができません。それでも削除しますか？',
          style: TextStyle(fontSize: 28),
        ),
        actions: <Widget>[
          // ボタン領域
          FlatButton(
            child: const Text(
              'キャンセル',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Container(
              color: Colors.red,
              padding: const EdgeInsets.all(10),
              child: const Text(
                '削除する',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () {
              homeRoomProvider.deleteHomeRoom(id);
              Navigator.pop(context);
              _confirmPopUp(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> editAlertPopUp(
  BuildContext context,
  int id,
) async {
  final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
  final homeroom = homeRoomProvider.getHomeRoom(id);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)), //this right here
          child: Container(
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: '学年'),
                    initialValue: homeroom.grade,
                    onChanged: homeRoomProvider.handleChangeGrade,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: '組'),
                    initialValue: homeroom.lectureClass,
                    onChanged: homeRoomProvider.handleChangeLectureClass,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: RaisedButton(
                      onPressed: () {
                        homeRoomProvider.editHomeRoom(id);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

Future<void> _confirmPopUp(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          '削除しました',
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                'ホーム画面に戻ります。',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('確認'),
            onPressed: () {
              Navigator.popUntil(
                context,
                // homeではない方がいいかも
                ModalRoute.withName('/home'),
              );
            },
          ),
        ],
      );
    },
  );
}
