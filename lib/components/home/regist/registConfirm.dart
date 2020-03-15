import 'package:lecture_performance_app/providers/HomeRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/common/seatView/editSeatView.dart';

//routerで渡される値
class HomeRegistConfirmArgument {
  final String grade;
  final String lectureClass;
  final List<String> seatMap;
  HomeRegistConfirmArgument(this.grade, this.lectureClass, this.seatMap);
}

class HomeRegistConfirm extends StatelessWidget {
  static const routeName = '/home/regist/confirm';
  @override
  Widget build(BuildContext context) {
    final HomeRegistConfirmArgument arg =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('登録確認画面'),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeRoomProvider()),
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
  final String grade;
  final String lectureClass;
  final List<String> seatMap;
  RegistConfirmMap({this.grade, this.lectureClass, this.seatMap});
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);

    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "以下の内容で登録しますか？",
            style: TextStyle(fontSize: 38, fontWeight: FontWeight.w300),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "クラス名",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              grade + "年 " + lectureClass + "組",
              style: TextStyle(fontSize: 32),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "座席表",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 200.0, left: 200),
            child: SeatMap(
              seatMap: seatMap,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: ButtonTheme(
              minWidth: 300,
              height: 50,
              child: RaisedButton(
                child: Text(
                  "登録する",
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

class SeatMap extends StatelessWidget {
  final List<String> seatMap;
  SeatMap({this.seatMap});
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: homeRoomProvider.mapSeat.length,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
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

Future<void> _neverSatisfied(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          '登録完了しました',
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'ホーム画面に戻ります。',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('確認'),
            onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName("/home")); 
            },
          ),
        ],
      );
    },
  );
}
