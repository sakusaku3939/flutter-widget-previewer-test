import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_state.dart';

final homeNotifierProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeState();
}
