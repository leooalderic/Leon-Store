import 'package:leon_flutter/data/freefire_product.dart';
import 'package:leon_flutter/models/product.dart';
import 'base_game_page.dart';

class FreeFirePage extends BaseGamePage {
  const FreeFirePage({super.key});

  @override
  String get gameTitle => "Free Fire";

  @override
  List<Product> get instantProducts => FreeFireProductData.diamondList;

  @override
  List<Product> get passProducts => FreeFireProductData.passList;

  @override
  BaseGamePageState<BaseGamePage> createState() => _FreeFirePageState();
}

class _FreeFirePageState extends BaseGamePageState<FreeFirePage> {}
