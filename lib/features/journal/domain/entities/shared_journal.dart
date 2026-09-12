import 'journal.dart';
class SharedJournal {
  final String uid;
  final String userUid;
  final int journalId;
  final Journal journal;
  final DateTime sharedAt;

  const SharedJournal({
    required this.uid,
    required this.journalId,
    required this.userUid,
    required this.journal,
    required this.sharedAt
  });

  SharedJournal copyWith ({
    Journal? journal
  }){
    return SharedJournal(
      uid: uid, 
      journalId: journalId, 
      userUid: userUid, 
      journal: journal ?? this.journal, 
      sharedAt: sharedAt
    );
  }
}