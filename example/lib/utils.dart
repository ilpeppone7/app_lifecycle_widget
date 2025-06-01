import 'dart:math';
import 'dart:ui';

Color randomColor() {
  final random = Random(DateTime.now().millisecondsSinceEpoch);
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}