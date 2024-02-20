/// Custom Firestore error
class FirestoreError extends Error {
  final String message;

  FirestoreError(this.message);
}
