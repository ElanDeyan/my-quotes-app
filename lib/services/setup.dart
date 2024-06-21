import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

void servicesSetup() {
  timeago.setLocaleMessages('pt', timeago.PtBrMessages());
  SharedPreferences.setPrefix('myQuotes');
}
