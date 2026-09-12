import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elcinorch/features/journal/domain/entities/journal.dart';
import '../../domain/entities/shared_journal.dart';

class SharedJournalModel extends SharedJournal {
  const SharedJournalModel({
    required super.uid,
    required super.userUid,
    required super.journalId,
    required super.journal,
    required super.sharedAt
  });

  factory SharedJournalModel.fromFirestore({
    required String uid,
    required Map<String, dynamic> data
  }) {
    return SharedJournalModel(
      uid: uid,
      userUid: data['user_uid'] as String,
      journalId: data['journal_id'] as int,
      journal: Journal(
        id: data['journal_id'] as int, 
        title: data['title'] as String, 
        body: data['body'] as String, 
        createdAt: (data['created_at'] as Timestamp).toDate()
      ),
      sharedAt: (data['shared_at'] as Timestamp).toDate()
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_uid': userUid,
      'journal_id': journalId,
      'title': journal.title,
      'body': journal.body,
      'created_at': Timestamp.fromDate(journal.createdAt),
      'shared_at': FieldValue.serverTimestamp()
    };
  }
}