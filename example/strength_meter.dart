import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:sam_server_web_client/auth/password_strength/password_strength.dart';

void main() {
  initPolymer();
  var input = querySelector('input');
  input.onBlur.listen(passwordChanged);
  input.onKeyPress.listen((KeyEvent e) {
    if (e.keyCode == 13) {
      passwordChanged(e);
    }
  });
}
  
passwordChanged(Event e) {
  var input = querySelector('input');
  PasswordStrengthMeter meter = querySelector('password-strength');
  meter.password = input.value;
 
  meter.onCalculationDone.first.then((_) {
    print('RESULTS FOR ${input.value}');
    print('\tSCORE: ${meter.score}');
    print('\tENTROPY: ${meter.entropy}');
    print('\tCRACK TIME: ${meter.crackTime}');
    print('\tCRACK TIME DISPLAY: ${meter.crackTimeDisplay}');
  });
  
}