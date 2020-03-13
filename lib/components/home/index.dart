import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/classRoom/index.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/wire.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _incrementCounter() {
      Navigator.pushNamed(context, '/class');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: HomeView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  Future _initHomeRoom() async {
    var db = await initDB();
    var _homeRoomAPI = initHomeRoomAPI(db);
    var homeRooms = await _homeRoomAPI.getAllHomeRoom();
    return homeRooms;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initHomeRoom(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeRoomList(homeRoom: snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class HomeRoomList extends StatelessWidget {
  const HomeRoomList({Key key, this.homeRoom}) : super(key: key);
  final List<HomeRoom> homeRoom;
  @override
  Widget build(BuildContext context) {
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
                      homeRoom[index],
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
                        homeRoom[index].grade.toString() +
                            "年" +
                            homeRoom[index].lectureClass.toString() +
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
      itemCount: homeRoom == null ? 0 : homeRoom.length,
    );
  }
}
