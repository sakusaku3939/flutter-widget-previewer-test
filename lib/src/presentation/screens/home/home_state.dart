import '../preview_gallery/preview_gallery_screen.dart';
import '../result_summary/result_summary_screen.dart';

class HomeState {
  const HomeState({this.destinations = _defaultDestinations});

  final List<HomeDestination> destinations;
}

class HomeDestination {
  const HomeDestination({
    required this.title,
    required this.description,
    required this.routeName,
    required this.label,
  });

  final String title;
  final String description;
  final String routeName;
  final String label;
}

const _defaultDestinations = <HomeDestination>[
  HomeDestination(
    title: 'Preview Gallery',
    description: '画面幅ごとの表示、状態別カード、共通 Widget の見え方を確認します。',
    routeName: PreviewGalleryScreen.routeName,
    label: 'UI STATES',
  ),
  HomeDestination(
    title: 'Result Summary',
    description: '処理完了後など、通常フローでは到達しづらい結果画面を確認します。',
    routeName: ResultSummaryScreen.routeName,
    label: 'RESULT',
  ),
];
