

// file to store references to our database collections

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;



final usersRef = _db.collection('users');
final tokensRef = _db.collection('DeviceTokens');
final locationsRef = _db.collection('locations');
final notificationsRef = _db.collection('notifications');


final FirebaseStorage _storage = FirebaseStorage.instance;
final storageRef = _storage.ref();

final DateFormat timeFormat = DateFormat('E, h:mm a');

