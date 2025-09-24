import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/transaction.dart';
import '../data/joki_product.dart';
import '../utils/currency_formatter.dart';

class JokiPage extends StatefulWidget {
  const JokiPage({super.key});

  @override
  State<JokiPage> createState() => _JokiPageState();
}

class _JokiPageState extends State<JokiPage> {
  Product? selectedProduct;
  int quantity = 1;

  // Input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginViaController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController requestHeroController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transaction = selectedProduct != null
        ? Transaction(product: selectedProduct!, quantity: quantity)
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text("Joki Penurun Rank"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Akun
            _sectionCard(
              title: "Masukkan Data Akun",
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          decoration: _inputDecoration("Nickname", "Masukkan Nickname"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: passwordController,
                          decoration: _inputDecoration("Server", "Masukkan Server"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: loginViaController,
                          decoration: _inputDecoration("Jam Main", "Pilih Jam Main"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: nicknameController,
                          decoration: _inputDecoration("Id", "Masukkan Id"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: requestHeroController,
                          decoration: _inputDecoration("Tanggal main", "Masukkan Tanggal main"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: notesController,
                          decoration: _inputDecoration("Role (dapat berubah saat main)", "Masukkan Role (Contoh Roamer,Explane, Goldlane, Midlane, Jungler)"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[700],
                    child: const Text(
                      "Pastikan data yang anda masukkan sudah benar.",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Section Pilih Paket Joki
            _sectionCard(
              title: "Main Bareng/Match Win",
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: JokiProductData.rankList.map((p) => _productCard(p)).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Jumlah Pembelian
            _sectionCard(
              title: "Jumlah Slot",
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                    icon: const Icon(Icons.remove, color: Colors.white),
                  ),
                  Text("$quantity", style: const TextStyle(color: Colors.white, fontSize: 16)),
                  IconButton(
                    onPressed: () => setState(() => quantity++),
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Detail Transaksi
            _sectionCard(
              title: "Detail Transaksi",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Produk: ${selectedProduct?.name ?? '-'}",
                      style: const TextStyle(color: Colors.white70)),
                  Text("Harga: ${CurrencyFormatter.format(selectedProduct?.price ?? 0)}",
                      style: const TextStyle(color: Colors.white70)),
                  Text("Jumlah: $quantity", style: const TextStyle(color: Colors.white70)),
                  const Divider(color: Colors.white24),
                  Text(
                    "Total: ${transaction != null ? CurrencyFormatter.format(transaction.total) : '-'}",
                    style: const TextStyle(color: Color(0xFFD2A679), fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Pesan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2A679),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (transaction != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Berhasil memesan ${transaction.product.name} x${transaction.quantity} (${CurrencyFormatter.format(transaction.total)})",
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.shopping_bag, color: Colors.white),
                label: const Text("Pesan Sekarang!", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFD2A679), borderRadius: BorderRadius.circular(4)),
          child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: const Color.fromARGB(255, 7, 7, 7),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  Widget _productCard(Product product) {
    final isSelected = selectedProduct == product;
    return GestureDetector(
      onTap: () => setState(() => selectedProduct = product),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD2A679) : const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 14)),
            const SizedBox(height: 6),
            Text(CurrencyFormatter.format(product.price),
                style: TextStyle(color: isSelected ? Colors.black : const Color(0xFFD2A679), fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
