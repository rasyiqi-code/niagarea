import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TopupRequestDialog extends StatefulWidget {
  final String userName;
  const TopupRequestDialog({super.key, required this.userName});

  @override
  State<TopupRequestDialog> createState() => _TopupRequestDialogState();
}

class _TopupRequestDialogState extends State<TopupRequestDialog> {
  final _amountController = TextEditingController();
  final String _adminWhatsapp = "6281234567890"; // Ganti dengan nomor admin asli

  Future<void> _sendWhatsapp() async {
    final amount = _amountController.text.trim();
    if (amount.isEmpty) return;

    final message = "Halo Admin NiagaRea,\n\nSaya *${widget.userName}* ingin melakukan top-up saldo cloud sebesar *Rp $amount*.\n\nMohon instruksi pembayarannya.";
    final url = "https://wa.me/$_adminWhatsapp?text=${Uri.encodeComponent(message)}";
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Isi Saldo Cloud'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Silakan masukkan nominal top-up yang Anda inginkan:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal (Rp)',
                prefixText: 'Rp ',
                hintText: 'Misal: 50.000',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Metode Pembayaran (Admin):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  const Text('• Bank BCA: 1234567890\n• Bank BRI: 0987654321\n• QRIS: (Screenshot di WA)', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton.icon(
          onPressed: _sendWhatsapp,
          icon: const Icon(Icons.message),
          label: const Text('Konfirmasi via WA'),
        ),
      ],
    );
  }
}
