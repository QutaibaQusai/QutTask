import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('todo');
  List<String> noteList = [];
  final DateTime now = DateTime.now();
  final dateFormatter = DateFormat('dd MMM ');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: HexColor("#3c42c6"),
          centerTitle: true,
          title: Text(
            // DateTime.now().day.toString() +
            //     " " +
            //     DateTime.now().month.toString(),
            dateFormatter.format(now),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          toolbarHeight: 70,
        ),
        body: StreamBuilder(
            stream: collection.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor("#3c42c6"),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                documentSnapshot['note'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Expanded(child: Container()),
                              IconButton(
                                onPressed: () {
                                  editNote(
                                      callback: (y) {
                                        noteList[index] = y;
                                        setState(() {});
                                      },
                                      editValue: noteList[index]);
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.userPen,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteNote(index: index);
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.trashCan,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        floatingActionButton: CircleAvatar(
          radius: 30,
          backgroundColor: HexColor("#3c42c6"),
          child: IconButton(
            onPressed: () {
              showButtonSheet(
                  context: context,
                  callback: (x) async {
                    await collection.add({"note": x});
                    // noteList.add(x);
                    setState(() {});
                  });
            },
            icon: const Icon(Icons.add),
            color: Colors.white,
            iconSize: 30,
          ),
        ),
      ),
    );
  }

  void showButtonSheet(
      {required BuildContext context, required Function(String) callback}) {
    TextEditingController noteController = TextEditingController();
    showModalBottomSheet(
        // backgroundColor: Colors.red,
        // barrierColor: Colors.red,
        // clipBehavior: ,
        // scrollControlDisabledMaxHeightRatio: 10,
        showDragHandle: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        // backgroundColor: Colors.red,
        builder: (BuildContext context) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      FontAwesomeIcons.arrowLeft,
                      size: 20,
                      color: HexColor("#3c42c6"),
                    ),
                  ),
                  Text(
                    "Add Note",
                    style: TextStyle(fontSize: 16, color: HexColor("#3c42c6")),
                  ),
                  TextButton(
                    onPressed: () {
                      callback(noteController.text);
                      Navigator.pop(context);
                    },
                    child: Icon(
                      FontAwesomeIcons.bookmark,
                      size: 20,
                      color: HexColor("#3c42c6"),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: "Enter now Note",
                    labelText: "Enter now Note",
                    // helperText: "Enter now Note",
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor("#3c42c6"), width: 0.0),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  // edit note
  void editNote(
      {required Function(String) callback, required String editValue}) {
    TextEditingController editNoteController =
        TextEditingController(text: editValue);
    showModalBottomSheet(
      // backgroundColor: Colors.red,
      // barrierColor: Colors.red,
      // clipBehavior: ,
      // scrollControlDisabledMaxHeightRatio: 10,
      showDragHandle: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      // backgroundColor: Colors.red,
      builder: (BuildContext context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    FontAwesomeIcons.arrowLeft,
                    size: 20,
                    color: HexColor("#3c42c6"),
                  ),
                ),
                Text(
                  "Edit Note",
                  style: TextStyle(fontSize: 16, color: HexColor("#3c42c6")),
                ),
                TextButton(
                  onPressed: () {
                    callback(editNoteController.text);
                    Navigator.pop(context);
                  },
                  child: Icon(
                    FontAwesomeIcons.userPen,
                    size: 20,
                    color: HexColor("#3c42c6"),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: editNoteController,
                decoration: InputDecoration(
                  labelText: "Edit  Note",
                  // helperText: "Enter now Note",
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: HexColor("#3c42c6"), width: 0.0),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  // delete note
  void deleteNote({required index}) {
    noteList.removeAt(index);
    setState(() {});
  }
}
