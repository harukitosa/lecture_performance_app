import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/classRoom/index.dart';
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
        title: Text("Home"),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeRoomProvider()),
        ],
        child: Consumer<HomeRoomProvider>(
          builder: (context, counter, _) {
            return Center(
              child: HomeRoomList(),
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

class HomeRoomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    homeRoomProvider.getAllHomeRoom();
    return ListView.builder(
      itemBuilder: (context, int index) {
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
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 40.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      title: Text(
                        homeRoomProvider.homeRoom[index].grade +
                            "年" +
                            homeRoomProvider.homeRoom[index].lectureClass +
                            "組",
                        style: TextStyle(
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
