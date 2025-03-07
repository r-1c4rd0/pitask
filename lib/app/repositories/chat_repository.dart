import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addUserInfo(Map<String, dynamic> userData) async {
    try {
      await _firestore.collection("users").add(userData);
    } catch (e) {
      print("Erro ao adicionar usuário: $e");
    }
  }

  Future<QuerySnapshot> getUserInfo(String token) async {
    try {
      return await _firestore.collection("users").where("token", isEqualTo: token).get();
    } catch (e) {
      print("Erro ao buscar usuário: $e");
      rethrow;
    }
  }

  Future<QuerySnapshot> searchByName(String searchField) async {
    try {
      return await _firestore.collection("users").where('userName', isEqualTo: searchField).get();
    } catch (e) {
      print("Erro ao buscar por nome: $e");
      rethrow;
    }
  }

  Future<void> createMessage(Message message) async {
    try {
      await _firestore.collection("messages").doc(message.id).set(message.toJson());
    } catch (e) {
      print("Erro ao criar mensagem: $e");
    }
  }

  Future<void> deleteMessage(Message message) async {
    try {
      await _firestore.collection("messages").doc(message.id).delete();
    } catch (e) {
      print("Erro ao deletar mensagem: $e");
    }
  }

  Stream<QuerySnapshot> getUserMessages(String userId, {int perPage = 10}) {
    return _firestore
        .collection("messages")
        .where('visible_to_users', arrayContains: userId)
        .orderBy('time', descending: true)
        .limit(perPage)
        .snapshots();
  }

  Future<Message> getMessage(String messageId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection("messages").doc(messageId).get();
      return Message.fromDocumentSnapshot(doc);
    } catch (e) {
      print("Erro ao obter mensagem: $e");
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUserMessagesStartAt(String userId, DocumentSnapshot lastDocument, {int perPage = 10}) {
    return _firestore
        .collection("messages")
        .where('visible_to_users', arrayContains: userId)
        .orderBy('time', descending: true)
        .startAfterDocument(lastDocument)
        .limit(perPage)
        .snapshots();
  }

  Stream<List<Chat>> getChats(Message message) {
    updateMessage(message.id, {'read_by_users': message.readByUsers});
    return _firestore
        .collection("messages")
        .doc(message.id)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return query.docs.map((doc) => Chat.fromDocumentSnapshot(doc)).toList();
    });
  }

  Future<void> addMessage(Message message, Chat chat) async {
    try {
      await _firestore.collection("messages").doc(message.id).collection("chats").add(chat.toJson());
      await updateMessage(message.id, {'last_message': chat.toJson()}); // Corrigido erro anterior
    } catch (e) {
      print("Erro ao adicionar mensagem: $e");
    }
  }

  Future<void> updateMessage(String messageId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection("messages").doc(messageId).update(data);
    } catch (e) {
      print("Erro ao atualizar mensagem: $e");
    }
  }

  Future<String> uploadFile(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = _storage.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print("Erro ao fazer upload: $e");
      throw Exception(e.toString());
    }
  }
}
