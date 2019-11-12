


  // Future sendNotification(_nextPrayerTime, _nextPrayerName, _nextPrayerYear,
  //     _nextPrayerMonth, _nextPrayerDate) async {
  //   var nextPrayer = DateTime(
  //       _nextPrayerYear,
  //       _nextPrayerMonth,
  //       _nextPrayerDate,
  //       int.parse(pureTimeArray[0]),
  //       int.parse(pureTimeArray[1]));
  //   var nextPrayerDiff = nextPrayer.difference(DateTime.now());
  //   var initializeSettingsAndroid =
  //       new AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var initializeSettingsIOS = new IOSInitializationSettings();
  //   var initializationSettings = new InitializationSettings(
  //       initializeSettingsAndroid, initializeSettingsIOS);
  //   await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: onSelectNotification);

  //   var forAndroidNotification =
  //       AndroidNotificationDetails('0', 'PRAYER', 'CALL TO PRAYER',
  //           importance: Importance.High,
  //           priority: Priority.High,
  //           largeIcon: 'ico',
  //           largeIconBitmapSource: BitmapSource.Drawable,
  //           style: AndroidNotificationStyle.BigPicture,
  //           styleInformation: BigPictureStyleInformation(
  //             'ico',
  //             BitmapSource.Drawable,
  //             largeIcon: 'ico',
  //             largeIconBitmapSource: BitmapSource.Drawable,
  //             contentTitle: '<h1>Hello Big guy</h1>',
  //             summaryText: '<small>for big buy</small>',
  //             htmlFormatContent: true,
  //             htmlFormatSummaryText: true,
  //           ));
  //   var forIOSNotification = IOSNotificationDetails();
  //   var specifiedPlatfor =
  //       NotificationDetails(forAndroidNotification, forIOSNotification);
  //   // await _flutterLocalNotificationsPlugin.show(
  //   //     3, 'Pray', 'Go Pray Now', specifiedPlatfor);
  //   _flutterLocalNotificationsPlugin.schedule(
  //       0,
  //       '$nextPrayerName',
  //       '$nextPrayerTime',
  //       DateTime.now()
  //           .add(Duration(microseconds: nextPrayerDiff.inMicroseconds)),
  //       specifiedPlatfor);
  // }



//time api
  // Future<http.Response> _getApi() async {
  //   try {
  //     var response = await http.get(Uri.decodeFull(
  //         'http://api.aladhan.com/v1/calendar?latitude=6.465422&longitude=3.406448&method=20'));
  //     if (response.statusCode == 200) {
  //       var body = json.decode(response.body);
  //       var timings = body['data'][date - 1];
  //       timingsTomorrow = body['data'][date]; //['timings']['Fajr'];
  //       allPrayers['Fajir'] = timings['timings']['Fajr'];
  //       // allPrayers['Sunrise'] = timings['Sunrise'];
  //       allPrayers['Dhuhr'] = timings['timings']['Dhuhr'];
  //       allPrayers['Asr'] = timings['timings']['Asr'];
  //       // allPrayers['Sunset'] = timings['Sunset'];
  //       allPrayers['Maghrib'] = timings['timings']['Maghrib'];
  //       allPrayers['Isha'] = timings['timings']['Isha'];
  //       // allPrayers['Imsak'] = timings['Imsak'];
  //       // allPrayers['Midnight'] = timings['Midnight'];
  //       // print(timingsTomorrow);
  //       nextPrayerReady = true;
  //       // getPrayerTime();
  //       return response;
  //     }
  //     // await getPrayerTime();
  //   } catch (error) {
  //     print(error);
  //   }
  // }


  
  // void playAdhan() {
  //   assetsAudioPlayerAdhan
  //       .open(AssetsAudio(asset: 'Adhan.mp3', folder: 'assets/audio'));
  //   assetsAudioPlayerAdhan.playOrPause();
  // }

  // void stopAdhan() {
  //   assetsAudioPlayerAdhan.stop();
  //   _flutterLocalNotificationsPlugin.cancel(0);
  //   callingPrayer = false;
  // }

  // Future onSelectNotification(String payload) async {
  //   if (payload != null) {
  //     debugPrint('Notification payload ' + payload);
  //   }
  //   stopAdhan();
  // }