import 'package:lecture_performance_app/components/home/regist/registConfirm.dart';
import 'package:lecture_performance_app/providers/HomeRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/common/seatView/editSeatView.dart';

//routerで渡される値
class HomeRegistSeatArgument {
  final String grade;
  final String lectureClass;
  HomeRegistSeatArgument(this.grade, this.lectureClass);
}

class HomeRegistSeat extends StatelessWidget {
  static const routeName = '/home/regist/seat';
  @override
  Widget build(BuildContext context) {
    final HomeRegistSeatArgument arg =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(arg.grade + "年" + arg.lectureClass + "組"),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeRoomProvider()),
        ],
        child: Consumer<HomeRoomProvider>(
          builder: (context, counter, _) {
            return Center(
              child: RegistSeatMap(
                grade: arg.grade,
                lectureClass: arg.lectureClass,
              ),
            );
          },
        ),
      ),
    );
  }
}

class RegistSeatMap extends StatelessWidget {
  final String grade;
  final String lectureClass;
  RegistSeatMap({this.grade, this.lectureClass});
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);

    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "使用しない座席をタップしてください",
            style: TextStyle(fontSize: 32),
          ),
          Text(
            "*あとでも変更できます",
            style: TextStyle(fontSize: 18),
          ),
          SeatMap(),
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: ButtonTheme(
              minWidth: 300,
              height: 50,
              child: RaisedButton(
                child: Text(
                  "次へ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    HomeRegistConfirm.routeName,
                    arguments: HomeRegistConfirmArgument(
                      grade,
                      lectureClass,
                      homeRoomProvider.mapSeat,
                    ),
                  );
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
  final double padding;
  SeatMap({this.padding});
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
          return EditSeatView(homeRoomProvider.mapSeat[index], index, true);
        },
      ),
    );
  }
}
