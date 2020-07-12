import 'package:lecture_performance_app/components/home/regist/registConfirm.dart';
import 'package:lecture_performance_app/providers/HomeRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';

//routerで渡される値
class HomeStoreSeatArgument {
  HomeStoreSeatArgument(this.grade, this.lectureClass);
  final String grade;
  final String lectureClass;
}

class HomeStoreSeat extends StatelessWidget {
  static const routeName = '/home/store/seat';
  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context).settings.arguments as HomeStoreSeatArgument;
    return Scaffold(
      appBar: AppBar(
        title: Text('${arg.grade}年 ${arg.lectureClass}組'),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: HomeRoomProvider()),
        ],
        child: Consumer<HomeRoomProvider>(
          builder: (context, counter, _) {
            return Center(
              child: StoreSeatMap(
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

class StoreSeatMap extends StatelessWidget {
  const StoreSeatMap({this.grade, this.lectureClass});
  final String grade;
  final String lectureClass;
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);

    return Center(
      child: Column(
        children: <Widget>[
          const Text(
            '使用しない座席をタップしてください',
            style: TextStyle(fontSize: 32),
          ),
          const Text(
            '*あとでも変更できます',
            style: TextStyle(fontSize: 18),
          ),
          SeatMap(),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: ButtonTheme(
              minWidth: 300,
              height: 50,
              child: RaisedButton(
                child: const Text(
                  '次へ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    HomeStoreConfirm.routeName,
                    arguments: HomeStoreConfirmArgument(
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

@immutable
class SeatMap extends StatelessWidget {
  SeatMap({this.padding});
  final double padding;
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
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          return _editSeatView(homeRoomProvider.mapSeat[index], index);
        },
      ),
    );
  }
}

class _editSeatView extends StatelessWidget {
  const _editSeatView(this.flag, this.index);

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

