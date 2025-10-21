import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'product.dart';

class GameTransaction {
  final Product product;
  final int quantity;
  final DateTime date;
  final String game;      
  final String userId;
  final String server;
  final String payment;
  final double rating;

  GameTransaction({
    required this.product,
    required this.quantity,
    required this.date,
    required this.game,
    required this.userId,
    required this.server,
    required this.payment,
    required this.rating,
  });

  int get total => product.price * quantity;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'date': date.toIso8601String(),
        'game': game,
        'userId': userId,
        'server': server,
        'payment': payment,
        'rating': rating,
      };

  factory GameTransaction.fromJson(Map<String, dynamic> json) {
    return GameTransaction(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      date: DateTime.parse(json['date']),
      game: json['game'],
      userId: json['userId'],
      server: json['server'],
      payment: json['payment'],
      rating: (json['rating'] as num).toDouble(),
    );
  }

  static String encode(List<GameTransaction> transactions) => json.encode(
        transactions.map((tx) => tx.toJson()).toList(),
      );

  static List<GameTransaction> decode(String transactions) =>
      (json.decode(transactions) as List<dynamic>)
          .map<GameTransaction>((item) => GameTransaction.fromJson(item))
          .toList();
}

Future<void> saveTransaction(GameTransaction transaction) async {
  final prefs = await SharedPreferences.getInstance();
  final existingData = prefs.getStringList('transactions') ?? [];

  existingData.add(jsonEncode(transaction.toJson()));
  await prefs.setStringList('transactions', existingData);
}

Future<List<GameTransaction>> getAllTransactions() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getStringList('transactions') ?? [];

  return saved
      .map((item) => GameTransaction.fromJson(jsonDecode(item)))
      .toList();
}
