import 'dart:async';

import 'package:get/get.dart';

class VerificationTimerController extends GetxController {
  int _time = 120;

  get getTime => _time;
  late Timer _timer;
  bool _timerEnd = false;

  get isTimeEnd => _timerEnd;

  Future<void> wait() async {
    _time = 120;
    _timerEnd = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      update();
      if (_time > 1) {
        _time--;
      } else {
        _time = 0;
        _timerEnd = true;
        _timer.cancel();
      }
      update();
    });
  }
}
