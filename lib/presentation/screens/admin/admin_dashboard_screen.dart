import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/user_profile.dart';
import '../../providers/admin_provider.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Reseller'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama atau toko...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                fillColor: theme.colorScheme.surface,
              ),
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
        ),
      ),
      body: usersAsync.when(
        data: (users) {
          final filteredUsers = users.where((u) {
            final name = u.name.toLowerCase();
            final store = u.storeName.toLowerCase();
            return name.contains(_searchQuery) || store.contains(_searchQuery);
          }).toList();

          if (filteredUsers.isEmpty) {
            return const Center(child: Text('Tidak ada reseller ditemukan.'));
          }

          return ListView.builder(
            itemCount: filteredUsers.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return _UserCard(user: user);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _UserCard extends ConsumerWidget {
  final UserProfile user;
  const _UserCard({required this.user});

  void _showTopupDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Top-up: ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Toko: ${user.storeName}', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal Top-up',
                prefixText: 'Rp ',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(controller.text) ?? 0;
              if (amount <= 0) return;
              
              Navigator.pop(context);
              
              try {
                await ref.read(adminServiceProvider).manualTopup(user.uid, amount);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Top-up ${CurrencyFormatter.format(amount.toInt())} berhasil!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal top-up: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Lanjut Topup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withAlpha(25),
          child: Text(user.name[0].toUpperCase()),
        ),
        title: Text(user.name),
        subtitle: Text(user.storeName),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormatter.format(user.balance.toInt()),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('Saldo Cloud', style: TextStyle(fontSize: 10)),
          ],
        ),
        onTap: () => _showTopupDialog(context, ref),
      ),
    );
  }
}
