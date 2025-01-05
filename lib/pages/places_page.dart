import 'package:flutter/material.dart';
import 'place_detail_page.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gezilecek Yerler'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPlaceCard(
            context,
            'Nemrut Dağı',
            'UNESCO Dünya Mirası Listesi\'nde yer alan Nemrut Dağı, dev heykelleri ve eşsiz gün doğumu manzarasıyla ünlüdür. Kommagene Krallığı\'nın en önemli kutsal alanı olan Nemrut Dağı\'nda, Kral I. Antiochos\'un tanrılar ve atalarıyla birlikte resmedildiği dev heykeller bulunmaktadır. Özellikle gün doğumu ve gün batımında muhteşem manzaralar sunan bu tarihi alan, her yıl binlerce turisti ağırlamaktadır.',
            'assets/images/nemrut.jpg',
            ['Tarihi', 'Doğa', 'UNESCO'],
            'Kahta, Adıyaman',
            'https://maps.google.com/?q=37.9829,38.7414',
          ),
          const SizedBox(height: 16),
          _buildPlaceCard(
            context,
            'Perre Antik Kenti',
            'Roma döneminden kalma önemli bir antik kent olan Perre, kaya mezarları ve tarihi kalıntılarıyla dikkat çeker. Kommagene Krallığı\'nın beş büyük kentinden biri olan Perre, özellikle Roma döneminde önemli bir ticaret merkezi olmuştur. Antik kentte bulunan kaya mezarları, su sarnıçları ve Roma Çeşmesi gibi yapılar, dönemin mimari özelliklerini yansıtmaktadır.',
            'assets/images/perre.jpg',
            ['Tarihi', 'Antik Kent'],
            'Örenli, Adıyaman Merkez',
            'https://maps.google.com/?q=37.8744,38.3513',
          ),
          const SizedBox(height: 16),
          _buildPlaceCard(
            context,
            'Cendere Köprüsü',
            'Roma İmparatoru Septimius Severus döneminde yapılan tarihi köprü, hala ayakta ve kullanılmaktadır. MS 2. yüzyılda inşa edilen köprü, Roma mimarisinin en güzel örneklerinden biridir. 120 metre uzunluğunda ve 7 metre genişliğindeki köprü, tek kemerli yapısıyla dikkat çekmektedir. Köprünün yapımında kullanılan kesme taşlar, herhangi bir harç kullanılmadan birbirine kenetlenmiştir.',
            'assets/images/cendere.jpg',
            ['Tarihi', 'Mimari'],
            'Kahta, Adıyaman',
            'https://maps.google.com/?q=37.9333,38.6167',
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(
    BuildContext context,
    String title,
    String description,
    String imageUrl,
    List<String> tags,
    String location,
    String mapUrl,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceDetailPage(
                title: title,
                description: description,
                imageUrl: imageUrl,
                location: location,
                tags: tags,
                mapUrl: mapUrl,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'place_$title',
              child: Image.asset(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: tags.map((tag) => Chip(
                      label: Text(tag),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 