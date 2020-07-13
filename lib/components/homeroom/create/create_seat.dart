import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/homeroom/create/create_confirm.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/providers/homeroom_provider.dart';
import 'package:provider/provider.dart';

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
      body: Consumer<HomeRoomProvider>(
        builder: (context, counter, _) {
          return Center(
            child: StoreSeatMap(
              grade: arg.grade,
              lectureClass: arg.lectureClass,
            ),
          );
        },
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
          _NextButton(
            grade: grade,
            lectureClass: lectureClass,
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({
    Key key,
    @required this.grade,
    @required this.lectureClass,
  }) : super(key: key);

  final String grade;
  final String lectureClass;

  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return Padding(
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
                homeRoomProvider.newHomeRoomSeat,
              ),
            );
          },
        ),
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
        itemCount: homeRoomProvider.newHomeRoomSeat.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: config.seatWidth,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          return _EditSeatView(homeRoomProvider.newHomeRoomSeat[index], index);
        },
      ),
    );
  }
}

class _EditSeatView extends StatelessWidget {
  const _EditSeatView(this.flag, this.index);

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
