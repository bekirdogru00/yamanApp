import 'package:flutter/material.dart';
import 'add_place_page.dart';
import 'add_restaurant_page.dart';
import 'add_promotion_page.dart';
import 'add_news_page.dart';
import 'add_durak_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAdminCard(
              context,
              'Durak Ekle',
              Icons.directions_bus_filled,
              'Dolmuş durağı ekle',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddDurakPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildAdminCard(
              context,
              'Haber Ekle',
              Icons.newspaper,
              'Yeni haber veya duyuru ekle',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddNewsPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildAdminCard(
              context,
              'Gezilecek Yer Ekle',
              Icons.place,
              'Yeni turistik yer veya mekan ekle',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPlacePage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildAdminCard(
              context,
              'Restoran Ekle',
              Icons.restaurant,
              'Yeni restoran veya kafe ekle',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddRestaurantPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildAdminCard(
              context,
              'Kampanya Ekle',
              Icons.local_offer,
              'Restoranlara özel kampanya ekle',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPromotionPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 