import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> register(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Actualiza el perfil de Firebase con el nombre del usuario.
      await userCredential.user?.updateDisplayName(name);

      // Guarda la información del usuario en Firestore.
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCredential.user!.uid,
        'createdAt': Timestamp.now(),
      });

      print("Usuario registrado: ${userCredential.user?.email}");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error en el registro: ${e.message}');
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("Usuario ha iniciado sesión: $email");
      return true;
    } on FirebaseAuthException catch (e) {
      print('Error en el inicio de sesión: ${e.message}');
      return false;
    }
  }
}
