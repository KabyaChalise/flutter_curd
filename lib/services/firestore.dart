import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  // get collection of note
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  // Create
  Future<void> addNotes(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  // Read
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  // Update
  Future<void> updateNote(String docId, String newNotes) {
    return notes
        .doc(docId)
        .update({'note': newNotes, 'timestamp': Timestamp.now()});
  }

  // Delete
  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
}
