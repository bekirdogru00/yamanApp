import 'package:flutter/material.dart';
import '../constants/image_constants.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: const TabBar(
              tabs: [
                Tab(text: 'Restoranlar'),
                Tab(text: 'Kampanyalar'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildRestaurantsList(),
            _buildPromotionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantsList() {
    return ListView(
      children: [
        _buildRestaurantCard(
          'Çiğköfteci Ali Usta',
          'Geleneksel Adıyaman çiğköftesi',
          4.8,
          ['Çiğköfte', 'Geleneksel'],
          ImageConstants.cigkofteciAliUsta,
        ),
        _buildRestaurantCard(
          'Kebapçı Mehmet',
          'Meşhur Adıyaman kebabı',
          4.5,
          ['Kebap', 'Et'],
          ImageConstants.kebapciMehmet,
        ),
      ],
    );
  }

  Widget _buildPromotionsList() {
    return ListView(
      children: [
        _buildPromotionCard(
          'Çiğköfteci Ali Usta',
          '2 porsiyon çiğköfte alana 1 porsiyon bedava!',
          'Hafta içi 14:00-17:00 arası geçerli',
          DateTime(2024, 1, 20),
        ),
        _buildPromotionCard(
          'Kebapçı Mehmet',
          'Öğle menüsünde %20 indirim',
          'Her gün 12:00-15:00 arası geçerli',
          DateTime(2024, 1, 31),
        ),
      ],
    );
  }

  Widget _buildRestaurantCard(String name, String description, double rating, List<String> tags, String imageUrl) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: tags.map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: Colors.grey[200],
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(String restaurantName, String title, String conditions, DateTime validUntil) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_offer, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  restaurantName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              conditions,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Son geçerlilik: ${validUntil.day}/${validUntil.month}/${validUntil.year}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 