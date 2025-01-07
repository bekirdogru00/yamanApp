import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Gezilecek Yerler
  Future<void> addPlace({
    required String title,
    required String description,
    required String location,
    required List<String> tags,
    required File? imageFile,
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        // Resmi Storage'a yükle
        final ref = _storage.ref().child('places/${DateTime.now().millisecondsSinceEpoch}');
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      // Firestore'a veriyi ekle
      await _firestore.collection('places').add({
        'title': title,
        'description': description,
        'location': location,
        'tags': tags,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // İşletmeler
  Future<void> addBusiness({
    required String name,
    required String description,
    required String address,
    required String phone,
    required List<String> categories,
    required File? imageFile,
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        final ref = _storage.ref().child('businesses/${DateTime.now().millisecondsSinceEpoch}');
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      await _firestore.collection('businesses').add({
        'name': name,
        'description': description,
        'address': address,
        'phone': phone,
        'categories': categories,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Kampanyalar
  Future<void> addPromotion({
    required String title,
    required String description,
    required String businessId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      await _firestore.collection('promotions').add({
        'title': title,
        'description': description,
        'businessId': businessId,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Veri Getirme Metodları
  Stream<QuerySnapshot> getPlaces() {
    return _firestore.collection('places').orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getBusinesses() {
    return _firestore.collection('businesses').orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getPromotions() {
    return _firestore.collection('promotions')
        .where('endDate', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('endDate')
        .snapshots();
  }

  // Haberler
  Future<void> addNews({
    required String title,
    required String content,
    required String category,
    required DateTime publishDate,
    String? imageUrl,
  }) async {
    try {
      debugPrint('Haber ekleme başladı');
      debugPrint('Başlık: $title');
      debugPrint('Kategori: $category');
      debugPrint('Resim URL: $imageUrl');
      
      final data = {
        'title': title,
        'content': content,
        'category': category,
        'publishDate': Timestamp.fromDate(publishDate),
        'imageUrl': imageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      debugPrint('Firestore\'a eklenecek veri: $data');
      
      await _firestore.collection('news').add(data);
      debugPrint('Haber başarıyla eklendi');
    } catch (e, stackTrace) {
      debugPrint('Haber eklenirken hata oluştu: $e');
      debugPrint('Hata detayı: $stackTrace');
      throw Exception('Haber eklenirken bir hata oluştu: $e');
    }
  }

  Stream<QuerySnapshot> getNews() {
    return _firestore.collection('news')
        .orderBy('publishDate', descending: true)
        .snapshots();
  }
} 