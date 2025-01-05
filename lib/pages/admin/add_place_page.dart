import 'package:flutter/material.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final List<String> _selectedTags = [];
  String? _selectedImage;

  final List<String> _availableTags = [
    'Tarihi Site',
    'Doğa',
    'Manzara',
    'Arkeoloji',
    'Müze',
    'Park',
    'Cami',
    'Antik Kent',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gezilecek Yer Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Fotoğraf seçme alanı
              Card(
                child: InkWell(
                  onTap: () {
                    // TODO: Fotoğraf seçme işlemi eklenecek
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _selectedImage != null
                        ? Image.asset(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Fotoğraf Ekle',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // İsim alanı
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Mekan Adı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen mekan adını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Açıklama alanı
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen açıklama girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Konum alanı
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Konum',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen konum bilgisi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Etiketler
              const Text(
                'Etiketler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
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
                        content: Text('Mekan başarıyla eklendi'),
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