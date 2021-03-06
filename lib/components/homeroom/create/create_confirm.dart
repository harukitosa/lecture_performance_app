import 'package:flutter/material.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/providers/homeroom_provider.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class HomeStoreConfirmArgument {
  HomeStoreConfirmArgument(this.grade, this.lectureClass, this.seatMap);
  final String grade;
  final String lectureClass;
  final List<String> seatMap;
}

class HomeStoreConfirm extends StatelessWidget {
  static const routeName = '/home/store/confirm';
  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context).settings.arguments as HomeStoreConfirmArgument;
    return Scaffold(
      appBar: AppBar(
        title: const Text('登録確認画面'),
      ),
      body: Consumer<HomeRoomProvider>(
        builder: (context, counter, _) {
          return Center(
            child: StoreConfirmMap(
              grade: arg.grade,
              lectureClass: arg.lectureClass,
              seatMap: arg.seatMap,
            ),
          );
        },
      ),
    );
  }
}

class StoreConfirmMap extends StatelessWidget {
  const StoreConfirmMap({this.grade, this.lectureClass, this.seatMap});

  final String grade;
  final String lectureClass;
  final List<String> seatMap;
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            '以下の内容で登録しますか？',
            style: TextStyle(fontSize: 38, fontWeight: FontWeight.w300),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'クラス名',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '$grade 年 $lectureClass 組',
              style: const TextStyle(fontSize: 32),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '座席表',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 200, left: 200),
            child: SeatMap(
              seatMap: seatMap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: ButtonTheme(
              minWidth: 300,
              height: 50,
              child: RaisedButton(
                child: const Text(
                  '登録する',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  homeRoomProvider.saveHomeRoom(
                    grade,
                    lectureClass,
                  );
                  _resultPopup(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class SeatMap extends StatelessWidget {
  SeatMap({this.seatMap});

  final List<String> seatMap;
  final AppDataConfig config = AppDataConfig();
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: homeRoomProvider.newHomeRoomSeat.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: config.seatWidth,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return _ConfirmSeatView(seatMap[index], index);
        },
      ),
    );
  }
}

Future<void> _resultPopup(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          '登録完了しました',
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
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
          ),
        ],
      );
    },
  );
}

class _ConfirmSeatView extends StatelessWidget {
  const _ConfirmSeatView(this.flag, this.index);

  final String flag;
  final int index;
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return InkWell(
      onTap: () {
        homeRoomProvider.changeSeatState(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          color: flag == 'true' ? Colors.blue : Colors.grey,
          child: const Text(''),
        ),
      ),
    );
  }
}
