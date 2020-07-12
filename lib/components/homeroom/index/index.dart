import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/homeroom/show/index.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/homeroom_provider.dart';
import 'package:provider/provider.dart';

class HomeroomIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _incrementCounter() {
      Navigator.pushNamed(context, '/home/regist');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('クラス一覧'),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: HomeRoomProvider()),
        ],
        child: Consumer<HomeRoomProvider>(
          builder: (context, counter, _) {
            return Center(
              child: HomeRoomList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        label: const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'クラス登録',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

class HomeRoomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return ListView.builder(
      itemBuilder: (context, int index) {
        return Center(
          child: Container(
            width: 800,
            child: Center(child: _ListCard(homeRoomProvider.homeRoom[index])),
          ),
        );
      },
      itemCount:
          homeRoomProvider == null ? 0 : homeRoomProvider.homeRoom.length,
    );
  }
}

@immutable
class _ListCard extends StatelessWidget {
  const _ListCard(this.homeroom);
  final HomeRoom homeroom;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          HomeroomShow.routeName,
          arguments: HomeroomShowArgument(
            homeroom,
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(
              Icons.edit,
              color: Colors.blue,
              size: 40,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            title: Text(
              '${homeroom.grade}年${homeroom.lectureClass}組',
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
