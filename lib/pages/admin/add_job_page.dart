import 'package:flutter/material.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _salaryController = TextEditingController();
  String? _selectedJobType;
  final List<String> _selectedSkills = [];

  final List<String> _jobTypes = [
    'Tam Zamanlı',
    'Yarı Zamanlı',
    'Uzaktan',
    'Staj',
    'Proje Bazlı',
  ];

  final List<String> _availableSkills = [
    'MS Office',
    'İngilizce',
    'Muhasebe',
    'Yazılım',
    'Satış',
    'Pazarlama',
    'İletişim',
    'Yönetim',
    'Tasarım',
    'Sosyal Medya',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İş İlanı Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // İş pozisyonu
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'İş Pozisyonu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen iş pozisyonunu girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Şirket adı
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Şirket Adı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şirket adını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // İş türü
              DropdownButtonFormField<String>(
                value: _selectedJobType,
                decoration: const InputDecoration(
                  labelText: 'İş Türü',
                  border: OutlineInputBorder(),
                ),
                items: _jobTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedJobType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen iş türünü seçin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // İş açıklaması
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'İş Açıklaması',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen iş açıklamasını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Gereksinimler
              TextFormField(
                controller: _requirementsController,
                decoration: const InputDecoration(
                  labelText: 'Gereksinimler',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen gereksinimleri girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Maaş aralığı
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Maaş Aralığı',
                  border: OutlineInputBorder(),
                  hintText: 'Örn: 8.000₺ - 12.000₺',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen maaş aralığını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Yetenekler
              const Text(
                'Gerekli Yetenekler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _availableSkills.map((skill) {
                  final isSelected = _selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Kaydet butonu
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Kaydetme işlemi eklenecek
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('İş ilanı başarıyla eklendi'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 