import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //create profile
  Future<void> createProfile() async {
    
  }
  //gete profile
  //update profile
}

final userRe = Provider((ref) => UserRepository());
