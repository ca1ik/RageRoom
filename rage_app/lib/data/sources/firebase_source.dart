// lib/data/sources/firebase_source.dart
// Firebase Firestore & Authentication işlemleri için veri kaynağı.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/data/models/rage_session_model.dart';

class FirebaseSource {
  FirebaseSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final Logger _log = Logger();

  // ── Authentication ─────────────────────────────────────────────────────────

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Anonim giriş — hızlıca başlamak için.
  Future<UserCredential> signInAnonymously() async {
    return _auth.signInAnonymously();
  }

  /// Google ile giriş — istatistikler senkronize edilsin.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return _auth.signInWithCredential(credential);
    } catch (e) {
      _log.e('Google giriş hatası: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  // ── Firestore: Sessions ────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _sessionsRef(String userId) {
    return _firestore
        .collection(AppConstants.colUsers)
        .doc(userId)
        .collection(AppConstants.colSessions);
  }

  Future<void> createSession(RageSessionModel model) async {
    await _sessionsRef(model.userId).doc(model.id).set(model.toFirestore());
  }

  Future<void> updateSession(RageSessionModel model) async {
    await _sessionsRef(model.userId).doc(model.id).update(model.toFirestore());
  }

  Future<RageSessionModel?> getSession(String userId, String sessionId) async {
    final doc = await _sessionsRef(userId).doc(sessionId).get();
    if (!doc.exists) return null;
    return RageSessionModel.fromFirestore(doc);
  }

  Future<List<RageSessionModel>> getUserSessions(String userId) async {
    final query = await _sessionsRef(
      userId,
    ).orderBy('startedAt', descending: true).limit(50).get();

    return query.docs
        .map(
          (d) => RageSessionModel.fromFirestore(
            d as DocumentSnapshot<Map<String, dynamic>>,
          ),
        )
        .toList();
  }

  /// Kullanıcının toplam kırım sayısını Firestore'dan çeker.
  Future<int> getTotalBreaks(String userId) async {
    final userDoc =
        await _firestore.collection(AppConstants.colUsers).doc(userId).get();
    return (userDoc.data()?['totalBreaks'] as int?) ?? 0;
  }

  /// Toplam kırım sayısını atomik olarak artırır.
  Future<void> incrementTotalBreaks(String userId, int amount) async {
    await _firestore.collection(AppConstants.colUsers).doc(userId).set({
      'totalBreaks': FieldValue.increment(amount),
    }, SetOptions(merge: true));
  }
}
