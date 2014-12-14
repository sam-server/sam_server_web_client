
import 'dart:html';

import 'package:polymer/polymer.dart';

import 'package:sam_server_web_client/polymer_utils.dart';

InputElement confirmPassword;

void main() {
  initPolymer().run(() {
    polymerReady.then((_) {
      confirmPassword = document.getElementById('confirmPassword');
      confirmPassword.onBlur.listen(checkPasswordsMatch);
      confirmPassword.onKeyPress((KeyPressEvent e) {
        
      });
    });
  });
}
