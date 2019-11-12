// import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:workmanager/workmanager.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
AssetsAudioPlayer assetsAudioPlayerAdhan = AssetsAudioPlayer();
var islamicDate = ummAlquraCalendar.now();

List<String> _months = [
  'Muharram',
  'Safar',
  "Rabi' al-awwal",
  'Rabi-ul-Thani',
  'Jumada-l-Ula',
  'Jumada-th-Thaniyya',
  'Rajab',
  'Shaaban',
  'Ramadhan',
  'Shawwal',
  'Dhul Qadah',
  'Dhul Hijja'
];
List<int> _years = [];

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  DateTime currentTime;
  var month;
  var year;
  var date;
  var hours;
  var minutes;
  var seconds;
  var showTime;
  var allPrayers = {};
  var timingsTomorrow;
  var nextPrayerName;
  var nextPrayerTime;
  var nextPrayerYear;
  var nextPrayerMonth;
  var nextPrayerDate;
  var pureTimeArray;
  bool nextPrayerReady = false;
  bool callingPrayer = false;
  var hijriDaysPerMonth = [];
  var gregorianDaysPerMonth = [];
  var setToYear = islamicDate.hYear;
  var setToMonth = islamicDate.hMonth;
  String monthPicker = _months[islamicDate.hMonth];
  int yearPicker = islamicDate.hYear;
  var monthPickerG; // = _months[islamicDate.hMonth];
  int yearPickerG; // = islamicDate.hYear;
  // String monthPicker = islamicDate.longMonthName;
  @override
  Widget build(BuildContext context) {
    Widget time = Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.only(left: 10.0),
                child: ListTile(
                  title: Text(
                    '$islamicDate',
                    // '$hour:$min:$sec',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 25.0),
                  ),
                  subtitle: Text(
                    '$date/$month/$year',
                    // '$hour:$min:$sec',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 15.0, color: Colors.red),
                  ),
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: ListTile(
                title: nextPrayerReady
                    ? ListTile(
                        title: Text(
                          '$nextPrayerTime',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        subtitle: Text(
                          '$nextPrayerName',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 15.0),
                        ),
                      )
                    : Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 5.00,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                subtitle: Text(
                  '$showTime',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    //Month and year
    List<Widget> monthAndYears = [
      Expanded(
        flex: 2,
        child: Padding(
            child: Text('$yearPickerG'), padding: EdgeInsets.only(left: 20.0)),
      ),
      Expanded(
        flex: 2,
        child: new DropdownButton(
          value: yearPicker,
          onChanged: (int newVal) {
            updateYearPicker(newVal);
            print(monthPicker);
          },
          items: _years.map((int value) {
            return new DropdownMenuItem(
              child: Text(
                '$value',
                textAlign: TextAlign.left,
              ),
              value: value,
            );
          }).toList(),
        ),
      ),
      Expanded(
        flex: 5,
        child: new DropdownButton(
          value: monthPicker,
          onChanged: (String newVal) {
            updateMonthPicker(newVal);
            print(monthPicker);
          },
          items: _months.map((String value) {
            return new DropdownMenuItem(
              child: Text(
                '$value',
                textAlign: TextAlign.left,
              ),
              value: value,
            );
          }).toList(),
        ),
      ),
      Expanded(
        flex: 2,
        child: Text('$monthPickerG'),
      )
    ];
    List<Widget> calender = [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 1.0),
        height: 50,
        //MediaQuery.of(context).size.width,
        child: Row(
          children: monthAndYears,
        ),
      ),
      Divider(
        thickness: 3.0,
      ),
      Expanded(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _weekdays('Ithnayn', 'Mon', Colors.black),
                    _weekdays('Thulāthā', 'Tue', Colors.black),
                    _weekdays('Arba‘ā', 'Wed', Colors.black),
                    _weekdays('Khamīs', 'Thu', Colors.black),
                    _weekdays('Jumu\'ah', 'Fri', Colors.black),
                    _weekdays('Sabt', 'Sat', Colors.black),
                    _weekdays('Aḥad', 'Sun', Colors.black),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                Expanded(
                  flex: 2,
                  child: _calenderWeek(
                      hijriDaysPerMonth[0],
                      gregorianDaysPerMonth[0],
                      hijriDaysPerMonth[1],
                      gregorianDaysPerMonth[1],
                      hijriDaysPerMonth[2],
                      gregorianDaysPerMonth[2],
                      hijriDaysPerMonth[3],
                      gregorianDaysPerMonth[3],
                      hijriDaysPerMonth[4],
                      gregorianDaysPerMonth[4],
                      hijriDaysPerMonth[5],
                      gregorianDaysPerMonth[5],
                      hijriDaysPerMonth[6],
                      gregorianDaysPerMonth[6]),
                ),
                Expanded(
                  flex: 2,
                  child: _calenderWeek(
                      hijriDaysPerMonth[7],
                      gregorianDaysPerMonth[7],
                      hijriDaysPerMonth[8],
                      gregorianDaysPerMonth[8],
                      hijriDaysPerMonth[9],
                      gregorianDaysPerMonth[9],
                      hijriDaysPerMonth[10],
                      gregorianDaysPerMonth[10],
                      hijriDaysPerMonth[11],
                      gregorianDaysPerMonth[11],
                      hijriDaysPerMonth[12],
                      gregorianDaysPerMonth[12],
                      hijriDaysPerMonth[13],
                      gregorianDaysPerMonth[13]),
                ),
                Expanded(
                  flex: 2,
                  child: _calenderWeek(
                      hijriDaysPerMonth[14],
                      gregorianDaysPerMonth[14],
                      hijriDaysPerMonth[15],
                      gregorianDaysPerMonth[15],
                      hijriDaysPerMonth[16],
                      gregorianDaysPerMonth[16],
                      hijriDaysPerMonth[17],
                      gregorianDaysPerMonth[17],
                      hijriDaysPerMonth[18],
                      gregorianDaysPerMonth[18],
                      hijriDaysPerMonth[19],
                      gregorianDaysPerMonth[19],
                      hijriDaysPerMonth[20],
                      gregorianDaysPerMonth[20]),
                ),
                Expanded(
                  flex: 2,
                  child: _calenderWeek(
                      hijriDaysPerMonth[21],
                      gregorianDaysPerMonth[21],
                      hijriDaysPerMonth[22],
                      gregorianDaysPerMonth[22],
                      hijriDaysPerMonth[23],
                      gregorianDaysPerMonth[23],
                      hijriDaysPerMonth[24],
                      gregorianDaysPerMonth[24],
                      hijriDaysPerMonth[25],
                      gregorianDaysPerMonth[25],
                      hijriDaysPerMonth[26],
                      gregorianDaysPerMonth[26],
                      hijriDaysPerMonth[27],
                      gregorianDaysPerMonth[27]),
                ),
                Expanded(
                  flex: 2,
                  child: _calenderWeek(
                      hijriDaysPerMonth[28],
                      gregorianDaysPerMonth[28],
                      hijriDaysPerMonth[29],
                      gregorianDaysPerMonth[29],
                      hijriDaysPerMonth[30],
                      gregorianDaysPerMonth[30],
                      hijriDaysPerMonth[31],
                      gregorianDaysPerMonth[31],
                      hijriDaysPerMonth[32],
                      gregorianDaysPerMonth[32],
                      hijriDaysPerMonth[33],
                      gregorianDaysPerMonth[33],
                      hijriDaysPerMonth[34],
                      gregorianDaysPerMonth[34]),
                ),
              ],
            ),
          ),
        ),
      )
    ];
    List<Widget> appBody = [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        color: Colors.white54,
        child: time,
      ),
      Expanded(
        flex: 1,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: FlatButton(
            onPressed: () => {}, //sendNotification(),
            child: Text('datasds'),
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.75,
        color: Colors.white70,
        child: Column(
          children: calender,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black45,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     fit: BoxFit.fill,
        //     image: NetworkImage(
        //        "https://aboutkazakhstan.com/blog/wp-content/uploads/2011/05/kazakhstan-mosque-8.jpg"
        //        ),
        //   ),
        // ),
        child: Column(
          children: appBody,
        ),
      ),
    );
  }

  _weekdays(day, dayG, color) {
    return Expanded(
      flex: 2,
      child: ListTile(
        title: Text(
          '$day',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '$dayG',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.red),
        ),
      ),
    );
  }

  getTodayColor(_hijirah) {
    var color;
    if (_hijirah == islamicDate.hDay &&
        setToMonth == islamicDate.hMonth &&
        setToYear == islamicDate.hYear) {
      color = Colors.amberAccent;
    } else {
      color = Colors.white24;
    }
    return color;
  }

  _calenderDay(hijirah, gregorian, colorH, colorG) {
    return Expanded(
      flex: 2,
      child: Container(
        color: getTodayColor(hijirah),
        child: InkWell(
          child: ListTile(
            title: Text(
              '$hijirah',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorH,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              '$gregorian',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorG,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _calenderWeek(firstH, firstG, secondH, secondG, thirdH, thirdG, fouthH,
      fouthG, fifthH, fifthG, sixthH, sixthG, seventhH, seventhG) {
    return Container(
      child: Row(
        children: <Widget>[
          _calenderDay(firstH, firstG, Colors.black, Colors.red),
          _calenderDay(secondH, secondG, Colors.black, Colors.red),
          _calenderDay(thirdH, thirdG, Colors.black, Colors.red),
          _calenderDay(fouthH, fouthG, Colors.black, Colors.red),
          _calenderDay(fifthH, fifthG, Colors.black, Colors.red),
          _calenderDay(sixthH, sixthG, Colors.black, Colors.red),
          _calenderDay(seventhH, seventhG, Colors.black, Colors.red),
        ],
      ),
    );
  }

  void getHijrahDate(year, month) {
    bool startSameDay = false;
    bool endSameDay = false;
    hijriDaysPerMonth = [];
    gregorianDaysPerMonth = [];
    var _islamicDate;
    for (var i = 1; 30 >= i; i++) {
      var gregorianDate = islamicDate.hijriToGregorian(year, month, i);
      yearPickerG = gregorianDate.year;
      _islamicDate = ummAlquraCalendar.fromDate(gregorianDate);
      yearPicker = _islamicDate.hYear;
      if (_islamicDate.hDay == 1) {
        if (gregorianDate.day == 1) {
          startSameDay = true;
        }
        var firstWeekDay = _islamicDate.wekDay();
        for (var fillBefore = 0; fillBefore < firstWeekDay; fillBefore++) {
          hijriDaysPerMonth.add('');
          gregorianDaysPerMonth.add('');
        }
        hijriDaysPerMonth[_islamicDate.wekDay() - 1] = _islamicDate.hDay;
        gregorianDaysPerMonth[_islamicDate.wekDay() - 1] = gregorianDate.day;
      } else if (_islamicDate.hDay == _islamicDate.lengthOfMonth) {
        if (gregorianDate.day == _islamicDate.lengthOfMonth) {
          endSameDay = true;
        }
        hijriDaysPerMonth.add(_islamicDate.hDay);
        gregorianDaysPerMonth.add(gregorianDate.day);
        var lastDay = _islamicDate.lengthOfMonth;
        for (var fillAfter = lastDay + 1; fillAfter <= 35; fillAfter++) {
          hijriDaysPerMonth.add('');
          gregorianDaysPerMonth.add('');
        }
      } else {
        hijriDaysPerMonth.add(_islamicDate.hDay);
        gregorianDaysPerMonth.add(gregorianDate.day);
      }

      switch (gregorianDate.month) {
        case 1:
          monthPickerG =
              startSameDay && endSameDay ? "January" : "December/January";
          break;
        case 2:
          monthPickerG =
              startSameDay && endSameDay ? "February" : "January/February";
          break;
        case 3:
          monthPickerG =
              startSameDay && endSameDay ? "March" : "February/March";
          break;
        case 4:
          monthPickerG = startSameDay && endSameDay ? "March" : "March/April";
          break;
        case 5:
          monthPickerG = startSameDay && endSameDay ? "March" : "April/May";
          break;
        case 6:
          monthPickerG = startSameDay && endSameDay ? "March" : "May/June";
          break;
        case 7:
          monthPickerG = startSameDay && endSameDay ? "July" : "June/July";
          break;
        case 8:
          monthPickerG = startSameDay && endSameDay ? "August" : "July/August";
          break;
        case 9:
          monthPickerG =
              startSameDay && endSameDay ? "September" : "August/September";
          break;
        case 10:
          monthPickerG =
              startSameDay && endSameDay ? "October" : "September/October";
          break;
        case 11:
          monthPickerG =
              startSameDay && endSameDay ? "November" : "October/November";
          break;
        case 12:
          monthPickerG =
              startSameDay && endSameDay ? "December" : "November/December";
          break;
      }
    }
  }

  void updateMonthPicker(_newValue) {
    setState(() {
      switch (_newValue) {
        case 'Muharram':
          setToMonth = 1;
          break;
        case 'Safar':
          setToMonth = 2;
          break;
        case 'Rabi-ul-Awwal':
          setToMonth = 3;
          break;
        case 'Rabi-ul-Thani':
          setToMonth = 4;
          break;
        case 'Jumada-l-Ula':
          setToMonth = 5;
          break;
        case 'Jumada-th-Thaniyya':
          setToMonth = 6;
          break;
        case 'Rajab':
          setToMonth = 7;
          break;
        case 'Shaaban':
          setToMonth = 8;
          break;
        case 'Ramadhan':
          setToMonth = 9;
          break;
        case 'Shawwal':
          setToMonth = 10;
          break;
        case 'Dhul Qadah':
          setToMonth = 11;
          break;
        case 'Dhul Hijja':
          setToMonth = 12;
          break;
        default:
          setToMonth = islamicDate.hMonth;
      }
      getHijrahDate(setToYear, setToMonth);
      return monthPicker = _newValue;
    });
  }

  updateYearPicker(_newValue) {
    setState(() {
      setToYear = _newValue;
      yearPicker = _newValue;
    });

    getHijrahDate(setToYear, setToMonth);
    return yearPicker;
  }

//time api
  Future<http.Response> _getApi() async {
    var response;
    try {
      response = await http.get(Uri.decodeFull(
          'http://api.aladhan.com/v1/calendar?latitude=6.465422&longitude=3.406448&method=20'));
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        var timings = body['data'][date - 1];
        timingsTomorrow = body['data'][date]; //['timings']['Fajr'];
        allPrayers['Fajir'] = timings['timings']['Fajr'];
        // allPrayers['Sunrise'] = timings['Sunrise'];
        allPrayers['Dhuhr'] = timings['timings']['Dhuhr'];
        allPrayers['Asr'] = timings['timings']['Asr'];
        // allPrayers['Sunset'] = timings['Sunset'];
        allPrayers['Maghrib'] = timings['timings']['Maghrib'];
        allPrayers['Isha'] = timings['timings']['Isha'];
        // allPrayers['Imsak'] = timings['Imsak'];
        // allPrayers['Midnight'] = timings['Midnight'];
        // print(timingsTomorrow);
        nextPrayerReady = true;
        // getPrayerTime();
        print('working');
      }
    } catch (error) {
      Timer(Duration(seconds: 3), () {
        print('===============$error');
        Fluttertoast.showToast(
            msg: "Could not connect to the internet",
            backgroundColor: Colors.blueGrey,
            fontSize: 10,
            textColor: Colors.white,
            timeInSecForIos: 5,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
        _getApi();
      });
    }
    return response;
  }

  Future getPrayerTime() async {
    bool found = false;
    var _pureTimeArray;
    var _nextPrayerTime;
    var _nextPrayerName;
    var _nextPrayerYear;
    var _nextPrayerMonth;
    var _nextPrayerDate;
    if (assetsAudioPlayerAdhan.isPlaying.value == false) {
      stopAdhan();
    }
    allPrayers.forEach((key, value) {
      var pureTime = value.split(' ');
      _pureTimeArray = pureTime[0].toString().split(':');
      var prayerT = double.parse(_pureTimeArray[0]) +
          (double.parse(_pureTimeArray[1]) / 60);
      var timeNow = double.parse(new DateTime.now().toLocal().hour.toString()) +
          (double.parse(new DateTime.now().toLocal().minute.toString()) / 60);
      if (prayerT == timeNow) {
        //call prayer
        if (!callingPrayer) {
          playAdhan();
          callingPrayer = true;
          found = false;
        }
      }
      if (prayerT > timeNow) {
        if (!found) {
          _nextPrayerTime = value;
          _nextPrayerName = key;
          nextPrayerTime = _nextPrayerTime;
          nextPrayerName = _nextPrayerName;
          pureTimeArray = _pureTimeArray;
          _nextPrayerYear = DateTime.now().toLocal().year;
          _nextPrayerMonth = DateTime.now().toLocal().month;
          _nextPrayerDate = DateTime.now().toLocal().day;
          found = true;
        }
      }
    });
    if (!found && timingsTomorrow != null) {
      _nextPrayerTime = timingsTomorrow['timings']['Fajr'];
      _nextPrayerName = 'Fajir';
      _nextPrayerYear = int.parse(timingsTomorrow['date']['gregorian']['year']);
      _nextPrayerMonth =
          timingsTomorrow['date']['gregorian']['month']['number'];
      _nextPrayerDate = int.parse(timingsTomorrow['date']['gregorian']['day']);
      nextPrayerDate = _nextPrayerDate;
      nextPrayerTime = _nextPrayerTime;
      nextPrayerName = _nextPrayerName;
      pureTimeArray = _pureTimeArray;
    }
    // await sendNotification(_nextPrayerTime, _nextPrayerName, _nextPrayerYear,
    //     _nextPrayerMonth, _nextPrayerDate);
  }

  void playAdhan() {
    assetsAudioPlayerAdhan
        .open(AssetsAudio(asset: 'Adhan.mp3', folder: 'assets/audio'));
    assetsAudioPlayerAdhan.playOrPause();
  }

  void stopAdhan() {
    assetsAudioPlayerAdhan.stop();
    _flutterLocalNotificationsPlugin.cancel(0);
    callingPrayer = false;
  }

  void _timmer() async {
    setState(() {
      islamicDate = ummAlquraCalendar.now();
      currentTime = DateTime.now().toLocal();
      nextPrayerYear = currentTime.year;
      nextPrayerMonth = currentTime.month;
      nextPrayerMonth = currentTime.day;
      year = currentTime.year;
      month =
          currentTime.month <= 9 ? '0${currentTime.month}' : currentTime.month;
      date = currentTime.day <= 9 ? '0${currentTime.day}' : currentTime.day;
      hours = currentTime.hour <= 9 ? '0${currentTime.hour}' : currentTime.hour;
      minutes = currentTime.minute <= 9
          ? '0${currentTime.minute}'
          : currentTime.minute;
      seconds = currentTime.second <= 9
          ? '0${currentTime.second}'
          : currentTime.second;
      showTime = '$hours:$minutes:$seconds';
    });
    getPrayerTime();
  }

  @override
  void initState() {
    // for (var i = 1336; i <= 1500; i++) {
    for (var i = 1350; i <= 1450; i++) {
      _years.add(i);
    }
    getHijrahDate(setToYear, setToMonth);
    currentTime = DateTime.now().toLocal();
    Timer.periodic(Duration(seconds: 1), (t) {
      _timmer();
    });
    _getApi();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print('closed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.paused:
        print('paused');
        break;
      case AppLifecycleState.resumed:
        print('resumed');
        break;
      case AppLifecycleState.suspending:
        print('susoending');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload ' + payload);
    }
    stopAdhan();
  }
}
