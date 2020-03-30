import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/HomeRoomProvider.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';

class EditSeatArgument {
  final String grade;
  final String lectureClass;
  EditSeatArgument(this.grade, this.lectureClass);
}

class EditSeat extends StatelessWidget {
  static const routeName = '/admin/edit/seat';
  const EditSeat({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditSeatArgument arg = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(arg.grade + "年" + arg.lectureClass + "組" + " 座席表編集画面"),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeRoomProvider()),
        ],
        child: Consumer<HomeRoomProvider>(
          builder: (context, counter, _) {
            return Center(
              child: EditSeatMap(
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

class EditSeatMap extends StatelessWidget {
  final String grade;
  final String lectureClass;
  EditSeatMap({this.grade, this.lectureClass});
  @override
  Widget build(BuildContext context) {
    // final homeRoomProvider = Provider.of<HomeRoomProvider>(context);

    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "使用しない座席をタップしてください",
            style: TextStyle(fontSize: 32),
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
                onPressed: () {},
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
  final config = new AppDataConfig();
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
          crossAxisCount: config.seatWidth,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          return EditSeatView(
            homeRoomProvider.currentSeat[index].used,
            index,
            true,
          );
        },
      ),
    );
  }
}

class EditSeatView extends StatelessWidget {
  final String flag;
  final int index;
  final bool changeState;
  EditSeatView(this.flag, this.index, this.changeState);
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return InkWell(
      onTap: () {
        if (this.changeState) {
          homeRoomProvider.editSeatState(index);
        }
      },
      child: Container(
        padding: EdgeInsets.all(4.0),
        color: flag == "true" ? Colors.blue : Colors.grey,
        child: Text(""),
      ),
    );
  }
}
