import 'package:leon_flutter/data/roblox_product.dart';
import 'package:leon_flutter/models/product.dart';
import 'base_game_page.dart';

class RobloxPage extends BaseGamePage {
  const RobloxPage({super.key});

  @override
  String get gameTitle => "Roblox";

  @override
  List<Product> get instantProducts => RobloxProductData.robuxList;

  @override
  List<Product> get passProducts => RobloxProductData.premiumList;

  @override
  BaseGamePageState<BaseGamePage> createState() => _RobloxPageState();
}

class _RobloxPageState extends BaseGamePageState<RobloxPage> {}
