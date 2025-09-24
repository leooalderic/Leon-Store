import 'package:leon_flutter/data/pubg_product.dart';
import 'package:leon_flutter/models/product.dart';
import 'base_game_page.dart';

class PubgPage extends BaseGamePage {
  const PubgPage({super.key});

  @override
  String get gameTitle => "PUBG Mobile";

  @override
  List<Product> get instantProducts => PubgProductData.ucList;

  @override
  List<Product> get passProducts => PubgProductData.passList;

  @override
  BaseGamePageState<BaseGamePage> createState() => _PubgPageState();
}

class _PubgPageState extends BaseGamePageState<PubgPage> {}
