import 'package:flutter/material.dart';
import '../constants/image_constants.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: const TabBar(
              tabs: [
                Tab(text: 'Son Dakika'),
                Tab(text: 'Yerel'),
                Tab(text: 'Spor'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildNewsList([
              _NewsItem(
                title: 'Nemrut\'ta Turizm Rekoru',
                description: 'Nemrut Dağı\'nı ziyaret eden turist sayısı geçen yıla göre %30 arttı.',
                imageUrl: ImageConstants.haberTurizm,
                date: DateTime.now().subtract(const Duration(hours: 2)),
                category: 'Turizm',
              ),
              _NewsItem(
                title: 'Yeni Kültür Merkezi Açılıyor',
                description: 'Adıyaman\'ın en büyük kültür merkezi önümüzdeki ay kapılarını açıyor.',
                imageUrl: ImageConstants.haberKultur,
                date: DateTime.now().subtract(const Duration(hours: 4)),
                category: 'Kültür',
              ),
            ]),
            _buildNewsList([
              _NewsItem(
                title: 'Belediyeden Yeni Proje',
                description: 'Şehir merkezi yenileme projesi başlıyor.',
                imageUrl: ImageConstants.haberBelediye,
                date: DateTime.now().subtract(const Duration(hours: 1)),
                category: 'Yerel',
              ),
            ]),
            _buildNewsList([
              _NewsItem(
                title: 'Adıyaman Spor\'dan Önemli Galibiyet',
                description: 'Adıyaman Spor, deplasmanda önemli bir galibiyete imza attı.',
                imageUrl: ImageConstants.haberSpor,
                date: DateTime.now().subtract(const Duration(hours: 3)),
                category: 'Spor',
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList(List<_NewsItem> news) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        final item = news[index];
        return _buildNewsCard(item);
      },
    );
  }

  Widget _buildNewsCard(_NewsItem news) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.asset(
              news.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
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
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        news.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(news.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  news.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.thumb_up_outlined, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Beğen',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.share_outlined, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Paylaş',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Haber detay sayfasına yönlendirme eklenecek
                      },
                      child: const Text('Devamını Oku'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inHours < 24) {
      return '${difference.inHours} saat önce';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _NewsItem {
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final String category;

  _NewsItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.category,
  });
} 