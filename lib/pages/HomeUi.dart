// ignore_for_file: prefer_const_constructors, file_names, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController topicController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  void addpost() async {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Post",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Profile"),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                SizedBox(height: 10),
                Container(
                    height: 1,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    )),
                SizedBox(height: 15),
                TextField(
                  controller: topicController,
                  decoration: InputDecoration(
                      hintText: "Topic",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
                  child: ElevatedButton(
                      onPressed: () async {
                        String topic = topicController.text;
                        String description = descriptionController.text;
                        descriptionController.clear();
                        topicController.clear();
                        dynamic time = DateTime.now();
                        String user = FirebaseAuth
                            .instance.currentUser!.displayName
                            .toString();

                        await FirebaseFirestore.instance
                            .collection("Posts")
                            .add({
                          "Topic": topic.isEmpty ? "No Topic" : topic,
                          "Description": description.isEmpty
                              ? "No Description"
                              : description,
                          "Time": time,
                          "Post": user,
                        });
                        Future.delayed(Duration(seconds: 2));

                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[100])),
                      child: Text("Add Post")),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Row(
                children: const [
                  Text(
                    "Home",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Profile"),
                  ),
                ],
              ),
              SizedBox(height: 5),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Posts")
                      .orderBy("Time", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;

                              return Card(
                                color: Colors.lightBlue[100],
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    child: Text(
                                      data["Post"],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  title: Text(data["Topic"]),
                                  subtitle: Text(data["Description"]),

                                  // trailing: Text(data["Post By"]),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Text("No Data Found");
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addpost();
        },
        hoverColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
