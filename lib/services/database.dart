import "package:cloud_firestore/cloud_firestore.dart";

class DatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference ref;

  String path;

  DatabaseService({this.path}){
    ref = _db.collection(path);
  }

  Future updateExpenseEntry(Map<String, dynamic> data, String id) {
    return ref.doc(id).update(data);
  }

  Future deleteExpenseEntry(String id) {
    return ref.doc(id).delete();
  }

  Future addExpenseEntry(Map data){
    return ref.add(data);
  }

  Future<QuerySnapshot> getDocuments({String field, String filter}) {
    return ref.where(field, isEqualTo: filter).get();
  }

  Stream<QuerySnapshot> watchDocuments({String field, String filter}) {
    return ref.where(field, isEqualTo: filter).snapshots();
  }

  Stream<QuerySnapshot> allDocuments(){
    return ref.snapshots();
  }

  Future<QuerySnapshot> getAllDocuments(){
    return ref.get();
  }
}