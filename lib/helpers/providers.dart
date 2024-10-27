import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameProvider = StateProvider<String>((ref) {
  return 'John Doe';
});

final courseProvider = StateProvider<String>((ref) {
  return 'Course 1A';
});

final dateProvider = StateProvider<String>((ref) {
  return '21 September 2024';
});

final clubProvider = StateProvider<String>((ref) {
  return 'Tech Geeks Club';
});

final eventProvider = StateProvider<String>((ref) {
  return 'Event Name';
});

final idProvider = StateProvider<String>((ref) {
  return '123456';
});
