import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_uploader/Pages/pick_image.dart';
import '../provider/auth_provider.dart';
import '../widgets/video_player_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;
  File? videoFile;
  List<Reference>? videosList;
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _filteredDocs = [];
  searchFunction(String value) async {
    _filteredDocs = await FirebaseFirestore.instance
        .collection('user_data')
        .where('video_title', isGreaterThanOrEqualTo: value.toLowerCase())
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs;
    }).catchError((onError) {
      print(onError);
      return [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              model.signOut();
            },
          ),
          title: const Text(
            'Gallery',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text('Search Videos'),
                        content: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                              hintText: "Enter video title or category"),
                          onChanged: (value) {
                            setState(() {
                              searchFunction(value);
                            });
                          },
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                // Navigate to the first item in the filtered list
                                if (_filteredDocs.isNotEmpty) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => VideoPlayerWidget(
                                            videoUrl: _filteredDocs[0]
                                                ['video_path'],
                                            description: _filteredDocs[0]
                                                ['video_description'],
                                            title: _filteredDocs[0]
                                                ['video_title'],
                                            category: _filteredDocs[0]
                                                ['video_category'],
                                          )));
                                }
                              },
                              child: const Text('Search')),
                        ],
                      );
                    });
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onPressed: () {
                model.signOut();
              },
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.amber,
          focusColor: Colors.black,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const PickImage()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('user_data').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return (snapshot.hasData)
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        return Card(
                          elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Stack(children: [
                                  AspectRatio(
                                      aspectRatio: 2 / 1,
                                      child: Image.network(
                                        document['thumbnail_uri'],
                                        fit: BoxFit.fill,
                                      )),
                                  Positioned.fill(
                                      child: Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                        onPressed: () {
                                          if (snapshot.hasData) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        VideoPlayerWidget(
                                                          videoUrl: document[
                                                              'video_path'],
                                                          description: document[
                                                              'video_description'],
                                                          title: document[
                                                              'video_title'],
                                                          category: document[
                                                              'video_category'],
                                                        )));
                                          } else {
                                            const CircularProgressIndicator();
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.play_circle,
                                          size: 50,
                                          color: Colors.white,
                                        )),
                                  ))
                                ]),
                              ),
                              Text(
                                document['video_title'],
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const Divider(thickness: 1),
                              Text(document['video_description']),
                              SizedBox(height: 10,),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Location: ",style: TextStyle(fontSize: 15),),
                                  Text(document['latitude'].toString()),
                                  const SizedBox(width: 10,),
                                  Text(document['longitude'].toString()),
                                ],
                              ),
                              TextButton(
                                  onPressed: () {
                                    if (snapshot.hasData) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (_) => VideoPlayerWidget(
                                                    videoUrl:
                                                        document['video_path'],
                                                    description: document[
                                                        'video_description'],
                                                    title:
                                                        document['video_title'],
                                                    category: document[
                                                        'video_category'],
                                                  )));
                                    } else {
                                      const CircularProgressIndicator();
                                    }
                                  },
                                  child: const Text("Watch"))
                            ],
                          ),
                        );
                      },
                    )
                  : const CircularProgressIndicator();
            }),
      );
    });
  }
}
