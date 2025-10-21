import 'dart:convert';
import 'product.dart';

class SimpleGameTransaction {
  final Product product;
  final int quantity;
  final String gameTitle; 

  SimpleGameTransaction({
    required this.product,
    required this.quantity,
    required this.gameTitle,
  });

  int get total => product.price * quantity;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'gameTitle': gameTitle,
      };

  factory SimpleGameTransaction.fromJson(Map<String, dynamic> json) => SimpleGameTransaction(
        product: Product.fromJson(json['product']),
        quantity: json['quantity'],
        gameTitle: json['gameTitle'],
      );

  static String encode(List<SimpleGameTransaction> transactions) =>
      json.encode(transactions.map((tx) => tx.toJson()).toList());

  static List<SimpleGameTransaction> decode(String transactions) =>
      (json.decode(transactions) as List<dynamic>)
          .map<SimpleGameTransaction>((item) => SimpleGameTransaction.fromJson(item))
          .toList();
}
