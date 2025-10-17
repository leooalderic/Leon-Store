import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String orderId;
  final double total;

  const PaymentPage({
    super.key,
    required this.orderId,
    required this.total,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedMethod;
  bool isPaid = false;

  final List<String> methods = [
    "QRIS",
    "Dana",
    "OVO",
    "GoPay",
    "Virtual Account BCA",
    "Alfamart",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Metode Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total yang harus dibayar: Rp${widget.total.toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Pilih metode pembayaran:"),
            const SizedBox(height: 10),
            ...methods.map((m) => RadioListTile(
                  title: Text(m),
                  value: m,
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value.toString();
                    });
                  },
                )),
            const SizedBox(height: 20),
            if (selectedMethod != null && !isPaid)
              _buildPaymentDetail(),
            if (isPaid)
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 60),
                    SizedBox(height: 10),
                    Text("Pembayaran Berhasil!",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text("Metode: $selectedMethod",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Text("Kode Pembayaran: #${widget.orderId.substring(0, 6)}${selectedMethod!.substring(0, 3).toUpperCase()}"),
        const SizedBox(height: 10),
        const Text("Batas pembayaran: 24 jam sejak pemesanan"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isPaid = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text("Saya sudah bayar"),
        ),
      ],
    );
  }
}
