import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlaceDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final List<String> tags;
  final String mapUrl;

  const PlaceDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.tags,
    required this.mapUrl,
  });

  void _launchMap(BuildContext context) {
    Clipboard.setData(ClipboardData(text: mapUrl)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Konum bağlantısı kopyalandı'),
          action: SnackBarAction(
            label: 'Tamam',
            onPressed: () {},
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title),
              background: Hero(
                tag: 'place_$title',
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Etiketler
                  Wrap(
                    spacing: 8,
                    children: tags.map((tag) => Chip(
                      label: Text(tag),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Açıklama
                  const Text(
                    'Hakkında',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Konum
                  const Text(
                    'Konum',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Harita Butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchMap(context),
                      icon: const Icon(Icons.map),
                      label: const Text('Konumu Kopyala'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 