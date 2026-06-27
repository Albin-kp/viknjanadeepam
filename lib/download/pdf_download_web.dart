// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

bool downloadPdfFile(String path, String filename) {
  final url = Uri.base.resolve('assets/$path').toString();
  final anchor = html.AnchorElement(href: url)
    ..download = filename
    ..target = '_blank'
    ..style.display = 'none';
  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  return true;
}
