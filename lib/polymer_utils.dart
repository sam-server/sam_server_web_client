library polymer_utils;

import 'dart:async';
import 'dart:html';

Completer _polymerReady;

Future get polymerReady {
  if (_polymerReady == null) {
    _polymerReady = new Completer();
    window.addEventListener('polymer-ready', (_) {
      _polymerReady.complete();
    });
  }
  return _polymerReady.future;
}



