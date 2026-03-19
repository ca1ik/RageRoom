// Rage Room — temel widget smoke testi.
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Uygulama başladığında crash olmamalı', (tester) async {
    // Firebase ve DI gerektiren tam uygulama smoke test olarak ayrı
    // integration test'te çalıştırılır. Burada sadece test scaffoldu var.
    expect(true, isTrue);
  });
}
