import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum PreviewStatus {
  loading(
    title: 'Loading',
    description: 'Previewer で skeleton / progress 表示を確認する状態。',
    label: 'IN PROGRESS',
  ),
  empty(
    title: 'Empty',
    description: 'データがない場合の余白、説明文、誘導の見え方を確認。',
    label: 'NO DATA',
  ),
  error(
    title: 'Error',
    description: 'エラー色だけに頼らず、テキストで原因を伝える状態。',
    label: 'ACTION NEEDED',
  ),
  success(
    title: 'Success',
    description: '正常表示時の情報密度とカード階層を確認する状態。',
    label: 'READY',
  );

  const PreviewStatus({
    required this.title,
    required this.description,
    required this.label,
  });

  final String title;
  final String description;
  final String label;

  Color color(BuildContext context) {
    return switch (this) {
      PreviewStatus.loading => Theme.of(context).colorScheme.primary,
      PreviewStatus.empty => AppTokens.warning,
      PreviewStatus.error => Theme.of(context).colorScheme.error,
      PreviewStatus.success => AppTokens.success,
    };
  }
}
