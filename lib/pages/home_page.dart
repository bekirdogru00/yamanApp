import 'package:flutter/material.dart';
import '../constants/image_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstants.nemrutDagi),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Adıyaman\'a Hoş Geldiniz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Öne Çıkanlar'),
                const SizedBox(height: 10),
                _buildFeatureCard(
                  'Nemrut Dağı',
                  'UNESCO Dünya Mirası Listesi\'nde yer alan tarihi kalıntılar',
                  Icons.landscape,
                ),
                const SizedBox(height: 10),
                _buildFeatureCard(
                  'Perre Antik Kenti',
                  'Roma döneminden kalma etkileyici antik kent',
                  Icons.account_balance,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Güncel Etkinlikler'),
                const SizedBox(height: 10),
                _buildEventCard(
                  'Adıyaman Kültür Festivali',
                  'Bu hafta sonu şehir merkezinde',
                  '15 Ocak',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget _buildEventCard(String title, String location, String date) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(location),
                const Spacer(),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 