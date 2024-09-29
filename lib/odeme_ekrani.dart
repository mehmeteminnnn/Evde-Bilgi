import 'package:flutter/material.dart';

class OdemeEkrani extends StatelessWidget {
  final VoidCallback onPaymentSuccess;
  final double totalAmount; // Ödenecek tutarı tutan bir değişken

  const OdemeEkrani(
      {Key? key, required this.onPaymentSuccess, required this.totalAmount})
      : super(key: key);

  void _makePayment(BuildContext context) {
    // Burada ödeme işlemi yapılır (sanal POS veya ödeme işlemi entegrasyonu)
    // Ödeme başarılı olursa onPaymentSuccess fonksiyonu çağrılır
    onPaymentSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ödeme Ekranı'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Renk değişimi
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ödeme Yap',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Ödenecek Tutar:',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₺${totalAmount.toStringAsFixed(2)}', // Tutarı iki ondalık basamakla göster
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _makePayment(context); // Ödeme işlemi başlatılır
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple, // Buton rengi
                        foregroundColor: Colors.white, // Buton metin rengi
                        padding:
                            const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Ödemeyi Tamamla'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
