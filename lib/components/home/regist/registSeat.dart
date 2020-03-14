import 'package:lecture_performance_app/providers/HomeRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              child: RegistSeatMap(),
            );
          },
        ),
      ),
    );
  }
}

class RegistSeatMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}

class SeatMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return Padding(
        padding: EdgeInsets.all(0.0),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: homeRoomProvider.mapSeat.length,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 30),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 2,
          ),
          itemBuilder: (context, index) {
            return SeatView(homeRoomProvider.mapSeat[index], index);
          },
        ));
  }
}

class SeatView extends StatelessWidget {
  final String flag;
  final int index;
  SeatView(this.flag, this.index);
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return InkWell(
      onTap: () {
        homeRoomProvider.changeSeatState(index);
      },
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
          color: flag == "true" ? Colors.blue : Colors.black12,
          width: 100,
          height: 50,
          child: Text(""),
        ),
      ),
    );
  }
}
