import 'package:flutter/cupertino.dart';

class SplashProvider extends ChangeNotifier {
  bool isFinished = false;

  void splashChange(bool val) {
    isFinished = val;
    print(val);
    print(isFinished);

    notifyListeners();
  }
}
