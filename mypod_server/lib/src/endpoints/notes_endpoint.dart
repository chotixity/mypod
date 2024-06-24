import 'package:serverpod/server.dart';
import 'package:serverpod_auth_server/module.dart';
import '../generated/protocol.dart';

class NotesEndpoint extends Endpoint {
  // Endpoint implementation goes here
  Future<void> createNote(Session session, Note note) async {
    await Note.db.insertRow(session, note);
  }

  Future<void> deleteNote(Session session, Note note) async {
    await Note.db.deleteRow(session, note);
  }

  Future<void> editNote(Session session, Note note) async {
    await Note.db.updateRow(session, note);
  }

  //TODO: Fix this method to fetch only current use
  Future<List<Note>> getAllNotes(Session session) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    return await Note.db.find(
      session,
      orderBy: (t) => t.id,
      where: (t) => t.createdById.equals(userId),
      include: Note.include(createdBy: UserInfo.include()),
    );
  }
}
