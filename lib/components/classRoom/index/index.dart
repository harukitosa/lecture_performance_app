import 'package:flutter/material.dart';
// import 'package:lecture_performance_app/components/home/regist/registConfirm.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/common/seatView/classSeatView.dart';

//routerで渡される値
class ClassRoomArgument {
  final HomeRoom homeRoom;
  ClassRoomArgument(this.homeRoom);
}

class ClassRoom extends StatelessWidget {
  static const routeName = '/class';
  @override
  Widget build(BuildContext context) {
    final ClassRoomArgument args = ModalRoute.of(context).settings.arguments;
    void _incrementCounter() {
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(args.homeRoom.grade + "年" + args.homeRoom.lectureClass + "組"),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => ClassRoomProvider(args.homeRoom.id)),
        ],
        child: Consumer<ClassRoomProvider>(
          builder: (context, counter, _) {
            return Center(
              child: RegistSeatMap(
                homeRoomID: args.homeRoom.id,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class RegistSeatMap extends StatelessWidget {
  final String grade;
  final String lectureClass;
  final int homeRoomID;
  RegistSeatMap({this.grade, this.lectureClass, this.homeRoomID});
  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);

    return Center(
      child: Column(
        children: <Widget>[
          SeatMap(
            homeRoomID: homeRoomID,
          ),
          Text("黒板"),
          // Padding(
          //   padding: EdgeInsets.only(top: 6),
          //   child: ButtonTheme(
          //     minWidth: 300,
          //     height: 50,
          //     child: RaisedButton(
          //       child: Text(
          //         "次へ",
          //         style: TextStyle(
          //           fontSize: 18,
          //         ),
          //       ),
          //       color: Colors.red,
          //       textColor: Colors.white,
          //       onPressed: () {},
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SeatMap extends StatelessWidget {
  final int homeRoomID;
  SeatMap({this.homeRoomID});
  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: classRoomProvider.viewSeat.length,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 50),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: classRoomProvider.viewWidth,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            return ClassRoomSeatView(
                classRoomProvider.viewSeat[index].used, index, true);
          },
        ),
      ),
    );
  }
}
