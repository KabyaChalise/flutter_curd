import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curd/services/firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firestore
  final Firestore firestore = Firestore();
  final TextEditingController textController = TextEditingController();
// open a box for note
  void openBox({String? docId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(),
              content: TextField(
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  color: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(7)),
                  onPressed: () {
                    if (docId == null) {
                      firestore.addNotes(textController.text);
                    } else {
                      firestore.updateNote(docId, textController.text);
                    }
                    textController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Notes",
            style: GoogleFonts.baloo2(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              
            )),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        onPressed: openBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore.getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = notesList[index];
                    String docId = document.id;
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String noteText = data['note'];
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: ListTile(
                          tileColor: Colors.grey.shade400,
                          title: Text(noteText),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => openBox(docId: docId),
                                icon: const Icon(Icons.settings),
                              ),
                              IconButton(
                                onPressed: () => firestore.deleteNote(docId),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          )),
                    );
                  });
            } else {
              return const Text("No Notes");
            }
          }),
    );
  }
}
