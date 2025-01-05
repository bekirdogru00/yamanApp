import 'package:flutter/material.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: ListView(
              children: [
                _buildJobCard(
                  'Yazılım Geliştirici',
                  'ABC Teknoloji',
                  'Tam Zamanlı',
                  'Flutter ve React Native deneyimi olan yazılım geliştirici aranıyor.',
                  ['Flutter', 'React Native', 'Mobile'],
                  '8.000₺ - 12.000₺',
                ),
                _buildJobCard(
                  'Satış Danışmanı',
                  'XYZ Mağazası',
                  'Tam Zamanlı',
                  'Perakende satış deneyimi olan satış danışmanı aranıyor.',
                  ['Satış', 'Perakende'],
                  '5.500₺ - 7.000₺',
                ),
                _buildJobCard(
                  'Garson',
                  'Lezzet Restaurant',
                  'Yarı Zamanlı',
                  'Deneyimli garson aranıyor. Hafta sonları çalışabilecek.',
                  ['Restoran', 'Servis'],
                  '4.500₺ - 6.000₺',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: İlan verme sayfasına yönlendirme eklenecek
        },
        icon: const Icon(Icons.add),
        label: const Text('İlan Ver'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'İş ara...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('Tam Zamanlı'),
          const SizedBox(width: 8),
          _buildFilterChip('Yarı Zamanlı'),
          const SizedBox(width: 8),
          _buildFilterChip('Uzaktan'),
          const SizedBox(width: 8),
          _buildFilterChip('Staj'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      onSelected: (bool selected) {
        // TODO: Filtre işlemleri eklenecek
      },
    );
  }

  Widget _buildJobCard(String title, String company, String type, String description, List<String> skills, String salary) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                        company,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(type),
                  backgroundColor: Colors.blue[100],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) => Chip(
                label: Text(skill),
                backgroundColor: Colors.grey[200],
              )).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  salary,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Başvuru sayfasına yönlendirme eklenecek
                  },
                  child: const Text('Başvur'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 