import 'package:polymer/polymer.dart';

@CustomTag('asset-base')
class AssetBaseElement extends PolymerElement {

  @published
  String href;

  @published
  String name;

  @published
  String description;

  @published
  Money price;

  AssetBaseElement.created(): super.created();
}