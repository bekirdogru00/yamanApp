import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({Key? key}) : super(key: key);

  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  late List<Map<String, dynamic>> pharmacies;
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    _initializePharmacies();
  }

  void _initializePharmacies() {
    // Günün başlangıcını al (saat 00:00)
    DateTime today = DateTime(currentDate.year, currentDate.month, currentDate.day);
    
    pharmacies = [
      {
        'name': 'Merkez Eczanesi',
        'address': 'Atatürk Bulvarı No:123',
        'phone': '0416 123 45 67',
        'location': {'latitude': 37.764751, 'longitude': 38.278561},
        'isOnDuty': true,
        'dutyStartTime': today,
        'dutyEndTime': today.add(const Duration(days: 1)),
      },
      {
        'name': 'Yaman Eczanesi',
        'address': 'Gölbaşı Caddesi No:456',
        'phone': '0416 234 56 78',
        'location': {'latitude': 37.763456, 'longitude': 38.276543},
        'isOnDuty': false,
        'dutyStartTime': today.add(const Duration(days: 1)),
        'dutyEndTime': today.add(const Duration(days: 2)),
      },
    ];
  }

  String formatDutyDate(DateTime dateTime) {
    return DateFormat('d MMMM yyyy', 'tr_TR').format(dateTime);
  }

  String formatDutyTime(DateTime dateTime) {
    return DateFormat.Hm('tr_TR').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nöbetçi Eczaneler'),
      ),
      body: ListView.builder(
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          final pharmacy = pharmacies[index];
          final isOnDuty = pharmacy['isOnDuty'] as bool;
          final dutyStartTime = pharmacy['dutyStartTime'] as DateTime;
          final dutyEndTime = pharmacy['dutyEndTime'] as DateTime;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      pharmacy['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (isOnDuty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Nöbetçi',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(pharmacy['address']),
                  const SizedBox(height: 4),
                  if (isOnDuty)
                    Text(
                      'Nöbet tarihi: ${formatDutyDate(dutyStartTime)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  if (isOnDuty)
                    Text(
                      'Nöbet bitiş: ${formatDutyTime(dutyEndTime)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  if (!isOnDuty)
                    Text(
                      'Gelecek nöbet: ${formatDutyDate(dutyStartTime)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () => _makePhoneCall(pharmacy['phone']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () => _openMaps(
                      pharmacy['location']['latitude'],
                      pharmacy['location']['longitude'],
                      pharmacy['name'],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Arama yapılamadı')),
      );
    }
  }

  Future<void> _openMaps(double latitude, double longitude, String name) async {
    final Uri launchUri = Uri.https(
      'www.google.com',
      'maps/dir/',
      {
        'api': '1',
        'destination': '$latitude,$longitude',
        'destination_name': name,
      },
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harita açılamadı')),
      );
    }
  }
} 