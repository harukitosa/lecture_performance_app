import 'package:flutter/material.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/homeroom.dart';
import 'package:lecture_performance_app/db/models/seat.dart';
import 'package:lecture_performance_app/providers/seat_edit_provider.dart';
import 'package:lecture_performance_app/wire.dart';
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
    final seat = initSeatAPI();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${arg.homeroom.grade} 年 ${arg.homeroom.lectureClass}組 座席表編集画面'),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: SeatEditProvider(seat: seat, homeroomID: arg.homeroom.id),
          ),
        ],
        child: Consumer<SeatEditProvider>(
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
    final seat = Provider.of<SeatEditProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: seat.list.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: config.seatWidth,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          return EditSeatView(seat.list[index]);
        },
      ),
    );
  }
}

class EditSeatView extends StatelessWidget {
  const EditSeatView(this.seat);
  final Seat seat;
  @override
  Widget build(BuildContext context) {
    final seatProvider = Provider.of<SeatEditProvider>(context);
    return InkWell(
      onTap: () {
        var flag = 'true';
        if (seat.used == 'true') {
          flag = 'false';
        }
        seatProvider.seatUpdate(
          seat.id,
          flag,
          seat.createTime,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        color: seat.used == 'true' ? Colors.blue : Colors.grey,
        child: const Text(''),
      ),
    );
  }
}
