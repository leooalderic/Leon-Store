import 'package:leon_flutter/data/ml_product.dart';
import 'package:leon_flutter/models/product.dart';
import 'base_game_page.dart';

class MobileLegendsPage extends BaseGamePage {
  const MobileLegendsPage({super.key});

  @override
  String get gameTitle => "Mobile Legends";

  @override
  List<Product> get instantProducts => ProductData.diamondList;

  @override
  List<Product> get passProducts => ProductData.passList;

  @override
  BaseGamePageState<BaseGamePage> createState() => _MobileLegendsPageState();
}

class _MobileLegendsPageState extends BaseGamePageState<MobileLegendsPage> {}
