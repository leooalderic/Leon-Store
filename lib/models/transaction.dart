import 'product.dart';

class Transaction {
  final Product product;
  final int quantity;

  Transaction({required this.product, required this.quantity});

  int get total => product.price * quantity;
}
