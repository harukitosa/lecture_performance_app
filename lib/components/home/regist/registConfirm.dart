import 'package:lecture_performance_app/providers/HomeRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/common/seatView/editSeatView.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';

//routerで渡される値
class HomeRegistConfirmArgument {
  HomeRegistConfirmArgument(this.grade, this.lectureClass, this.seatMap);
  final String grade;
  final String lectureClass;
  final List<String> seatMap;
}

class HomeRegistConfirm extends StatelessWidget {
  static const routeName = '/home/regist/confirm';
  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context).settings.arguments as HomeRegistConfirmArgument;
    return Scaffold(
      appBar: AppBar(
        title: const Text('登録確認画面'),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: HomeRoomProvider()),
        ],
        child: Consumer<HomeRoomProvider>(
          builder: (context, counter, _) {
            return Center(
              child: RegistConfirmMap(
                grade: arg.grade,
                lectureClass: arg.lectureClass,
                seatMap: arg.seatMap,
              ),
            );
          },
        ),
      ),
    );
  }
}

class RegistConfirmMap extends StatelessWidget {
  const RegistConfirmMap({this.grade, this.lectureClass, this.seatMap});

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
                  homeRoomProvider.registHomeRoom(
                    grade,
                    lectureClass,
                    seatMap,
                  );
                  _neverSatisfied(context);
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
        itemCount: homeRoomProvider.mapSeat.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: config.seatWidth,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return EditSeatView(seatMap[index], index, false);
        },
      ),
    );
  }
}

Future<void> _neverSatisfied(BuildContext context) async {
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
