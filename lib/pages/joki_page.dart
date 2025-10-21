import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'; 
import '../models/product.dart';
import 'package:leon_flutter/models/transaction_history.dart';
import '../data/joki_product.dart';
import '../utils/currency_formatter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class JokiPage extends StatefulWidget {
  const JokiPage({super.key});

  @override
  State<JokiPage> createState() => _JokiPageState();
}

class _JokiPageState extends State<JokiPage> {
  Product? selectedProduct;
  int quantity = 1;
  String? selectedPayment;
  double userRating = 3.0;

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController serverController = TextEditingController();
  final TextEditingController jamMainController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController tanggalMainController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  final List<String> paymentMethods = [
    "Dana",
    "OVO",
    "GoPay",
    "ShopeePay",
    "Transfer Bank (BCA/BRI/BNI)"
  ];

  @override
  Widget build(BuildContext context) {
    final transaction = selectedProduct != null
        ? GameTransaction(
            product: selectedProduct!,
            quantity: quantity,
            date: DateTime.now(),
            game: "Joki Penurun Rank",
            userId: idController.text,
            server: serverController.text,
            payment: selectedPayment ?? "-",
            rating: userRating,
          )
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Joki Penurun Rank",
          style: TextStyle(
            color: Color(0xFFD2A679),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              title: "Data Akun",
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _inputField(
                            "Nickname", "Masukkan Nickname", nicknameController),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _inputField(
                            "Server", "Masukkan Server", serverController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _inputField(
                            "Jam Main", "Masukkan Jam Main", jamMainController),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _inputField("ID", "Masukkan ID Akun", idController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showDatePickerDialog();
                          },
                          child: AbsorbPointer(
                            child: _inputField("Tanggal Main", "Pilih Tanggal",
                                tanggalMainController),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child:
                            _inputField("Role", "Roamer/Explane/dll", roleController),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _sectionCard(
              title: "Pilih Paket Joki",
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: JokiProductData.rankList
                    .map((p) => _productCard(p))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),

            _sectionCard(
              title: "Jumlah Slot",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _quantityButton(Icons.remove, () {
                    if (quantity > 1) setState(() => quantity--);
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "$quantity",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  _quantityButton(Icons.add, () => setState(() => quantity++)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _sectionCard(
              title: "Detail Transaksi",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Produk  : ${selectedProduct?.name ?? '-'}",
                      style: const TextStyle(color: Colors.white70)),
                  Text(
                      "Harga    : ${CurrencyFormatter.format(selectedProduct?.price ?? 0)}",
                      style: const TextStyle(color: Colors.white70)),
                  Text("Jumlah  : $quantity",
                      style: const TextStyle(color: Colors.white70)),
                  const Divider(color: Colors.white24),
                  Text(
                    "Total : ${transaction != null ? CurrencyFormatter.format(transaction.total) : '-'}",
                    style: const TextStyle(
                      color: Color(0xFFD2A679),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _sectionCard(
              title: "Metode Pembayaran",
              child: DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF2C2C2C),
                value: selectedPayment,
                items: paymentMethods.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedPayment = value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD2A679)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                hint: const Text(
                  "Pilih Metode Pembayaran",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

            const SizedBox(height: 16),
            _sectionCard(
              title: "Beri Rating",
              child: Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding:
                      const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() => userRating = rating);
                    print("Rating pengguna: $rating");
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2A679),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed:
                    transaction != null && selectedPayment != null
                        ? () => _showConfirmationDialog(transaction)
                        : null,
                child: const Text(
                  "Pesan Sekarang!",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(GameTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Konfirmasi Pesanan",
            style: TextStyle(
              color: Color(0xFFD2A679),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _confirmText("Produk", transaction.product.name),
              _confirmText("Jumlah", "${transaction.quantity}x"),
              _confirmText("Metode", selectedPayment ?? "-"),
              const Divider(color: Colors.white24),
              _confirmText("Total",
                  CurrencyFormatter.format(transaction.total),
                  isBold: true, color: const Color(0xFFD2A679)),
              const SizedBox(height: 10),
              _confirmText("Rating", "$userRating ⭐",
                  color: Colors.white70),
              const SizedBox(height: 10),
              const Text(
                "Pastikan data yang Anda masukkan sudah benar.",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("Batal", style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD2A679),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await saveTransaction(transaction);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Pesanan berhasil dikonfirmasi!")),
                );
              },
              child:
                  const Text("Konfirmasi", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDatePickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Pilih Tanggal Main",
            style: TextStyle(
              color: Color(0xFFD2A679),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: 350,
            width: 350,
            child: SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.single,
              backgroundColor: const Color(0xFF2C2C2C),
              todayHighlightColor: const Color(0xFFD2A679),
              selectionColor: const Color(0xFFD2A679),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  setState(() {
                    tanggalMainController.text =
                        "${args.value.day}/${args.value.month}/${args.value.year}";
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _confirmText(String label, String value,
      {bool isBold = false, Color color = Colors.white70}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "$label : $value",
        style: TextStyle(
          color: color,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFFD2A679),
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFD2A679)),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  Widget _inputField(
      String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label, hint),
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
            Text(product.name,
                style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 14)),
            const SizedBox(height: 6),
            Text(
              CurrencyFormatter.format(product.price),
              style: TextStyle(
                color:
                    isSelected ? Colors.black : const Color(0xFFD2A679),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD2A679),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black),
      ),
    );
  }
}
