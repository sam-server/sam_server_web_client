import 'package:polymer/polymer.dart';
import 'package:cs_elements/context_panel/context_panel.dart';

@CustomTag('main-context')
class MainContext extends ContextPanel {
  
  @override
  bool get trackHistory => true;
  
  @override
  String get trackName => "main-context";
  
  MainContext.created(): super.created();
}