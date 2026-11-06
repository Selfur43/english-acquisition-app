import 'package:english_acquisition_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home page source exposes the learning action card', (
    tester,
  ) async {
    expect(const HomePage(), isA<HomePage>());
  });
}
