import 'package:flutter/foundation.dart';

import 'home_state.dart';

class HomeNotifier extends ChangeNotifier {
  HomeNotifier([this._state = const HomeState()]);

  HomeState _state;

  HomeState get state => _state;

  set state(HomeState value) {
    if (identical(_state, value)) {
      return;
    }
    _state = value;
    notifyListeners();
  }
}
