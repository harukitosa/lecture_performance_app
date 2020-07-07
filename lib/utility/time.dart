//sqliteに合わせて作成している
String getNowTime() {
  final _dateTimeNow = DateTime.now();
  final individualMakers = _dateTimeNow.toString().split('.');
  return individualMakers[0];
}
