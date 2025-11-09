import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserProfileRepository {
  User? get currentUser;

  Future<ImageProvider> changeProfilePicture();
  Future<void> signOut();
}

class UserProfileRepositoryImpl extends UserProfileRepository{
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final ImagePicker _imagePicker;

  UserProfileRepositoryImpl({
    FirebaseAuth? auth,
    FirebaseStorage? storage,
    ImagePicker? imagePicker,
}):     _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _imagePicker = imagePicker ?? ImagePicker();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<ImageProvider<Object>> changeProfilePicture() async{
    final user = _auth.currentUser;
    if(user == null){
      throw FirebaseAuthException(code: "user-not-found");
    }

    final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      imageQuality: 80,
    );

    if(pickedFile == null){
      throw Exception("No image selected");
    }

    final File imageFile = File(pickedFile.path);

    final Reference storageRef = _storage.ref().child('profile_picture').child('${user.uid}.jpg');
    await storageRef.putFile(imageFile);

    final String downloadUrl = await storageRef.getDownloadURL();
    await user.updatePhotoURL(downloadUrl);
    await user.reload();
    return NetworkImage(downloadUrl);
  }


  @override
  Future<void> signOut() async{
    await _auth.signOut();
  }

}