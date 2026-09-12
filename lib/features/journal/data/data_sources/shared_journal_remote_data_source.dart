import '../models/shared_journal_model.dart';
import '../models/journal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elcinorch/core/services/auth_service.dart';

class SharedJournalRemoteDataSource {
  final FirebaseFirestore instance;
  final AuthService auth;

  SharedJournalRemoteDataSource({
    FirebaseFirestore? firestore,
    required this.auth
  }) : instance = firestore ?? FirebaseFirestore.instance;
  
  Future<List<SharedJournalModel>> getSharedJournals() async {
    final snapshot = await instance.collection("journals").get();

    return snapshot.docs.map((doc) => SharedJournalModel.fromFirestore(uid: doc.id, data: doc.data())).toList();
  }

  Future<SharedJournalModel> shareJournal({ 
    required String userUid, 
    required JournalModel journal
  }) async {
    final doc = instance.collection("journals").doc();
    
    await doc.set({
      'user_uid': userUid,
      'journal_id': journal.id,
      'title': journal.title,
      'body': journal.body,
      'created_at': Timestamp.fromDate(journal.createdAt),
      'shared_at': FieldValue.serverTimestamp()
    });

    final snapshot = await doc.get();
    final data = snapshot.data();

    return SharedJournalModel.fromFirestore(uid: snapshot.id, data: data!);
  }

  Future<void> updateSharedJournal({
    required String sharedJournalUid,
    required String title,
    required String body
  }) async {
    return instance.collection("journals").doc(sharedJournalUid).update({
      'title': title,
      'body': body
    });
  }

  Future<void> deleteSharedJournal(String journalUid) async {
    await instance.collection("journals").doc(journalUid).delete();
  }
}
