import 'package:flutter/material.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/homeroom_before_provider.dart';
import 'package:provider/provider.dart';

class SeatUpdateUsedArgument {
  SeatUpdateUsedArgument(this.homeroom);
  final HomeRoom homeroom;
}

class SeatUpdateUsed extends StatelessWidget {
  const SeatUpdateUsed({Key key}) : super(key: key);
  static const routeName = '/admin/edit/seat';

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context).settings.arguments as SeatUpdateUsedArgument;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${arg.homeroom.grade} 年 ${arg.homeroom.lectureClass}組 座席表編集画面'),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: HomeRoomBeforeProvider()),
        ],
        child: Consumer<HomeRoomBeforeProvider>(
          builder: (context, counter, _) {
            return const Center(
              child: EditSeatMap(),
            );
          },
        ),
      ),
    );
  }
}

class EditSeatMap extends StatelessWidget {
  const EditSeatMap();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const Text(
            '使用しない座席をタップしてください',
            style: TextStyle(fontSize: 32),
          ),
          SeatMap(),
        ],
      ),
    );
  }
}

class SeatMap extends StatelessWidget {
  SeatMap({this.padding});
  final double padding;
  final AppDataConfig config = AppDataConfig();
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomBeforeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: homeRoomProvider.currentSeat != null
            ? homeRoomProvider.currentSeat.length
            : 0,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: config.seatWidth,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          return EditSeatView(
            homeRoomProvider.currentSeat != null
                ? homeRoomProvider.currentSeat[index].used
                : 'false',
            index,
            changeState: true,
          );
        },
      ),
    );
  }
}

class EditSeatView extends StatelessWidget {
  const EditSeatView(this.flag, this.index, {this.changeState});

  final String flag;
  final int index;
  final bool changeState;
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomBeforeProvider>(context);
    return InkWell(
      onTap: () {
        if (changeState) {
          homeRoomProvider.editSeatState(index);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        color: flag == 'true' ? Colors.blue : Colors.grey,
        child: const Text(''),
      ),
    );
  }
}
