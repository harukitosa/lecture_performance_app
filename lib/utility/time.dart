//sqliteに合わせて作成している
String getNowTime() {
  var _dateTimeNow = DateTime.now();
  List individualMakers = _dateTimeNow.toString().split('.');
  return individualMakers[0];
}