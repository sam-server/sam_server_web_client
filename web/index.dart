import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:cs_elements/session/session.dart';

void main() {
  initPolymer();
  querySelector('img.logo').onClick.listen((evt) {
    window.location.href = '/';
  });
}