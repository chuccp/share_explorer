// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html';
Future<void> downloadUrl(String url) async {
  final anchor = AnchorElement(href: url)
    ..target = '_self';
  document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
