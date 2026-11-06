import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routing/app_router.dart';
import 'theme/app_theme.dart';

final class EnglishAcquisitionApp extends ConsumerWidget {
  const EnglishAcquisitionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: ref.watch(appRouterProvider),
    theme: AppTheme.light,
    title: 'English Acquisition',
  );
}
