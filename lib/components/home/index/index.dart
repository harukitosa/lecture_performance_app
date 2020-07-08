import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/classRoom/index/index.dart';
import 'package:lecture_performance_app/providers/HomeRoomProvider.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
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
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context)
      ..getAllHomeRoom();
    return ListView.builder(
      itemBuilder: (context, int index) {
        final grade = homeRoomProvider.homeRoom[index].grade;
        final lectureClass = homeRoomProvider.homeRoom[index].lectureClass;
        return Center(
          child: Container(
            width: 800,
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ClassRoom.routeName,
                    arguments: ClassRoomArgument(
                      homeRoomProvider.homeRoom[index],
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
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      title: Text(
                        '$grade 年 $lectureClass 組',
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount:
          homeRoomProvider == null ? 0 : homeRoomProvider.homeRoom.length,
    );
  }
}
