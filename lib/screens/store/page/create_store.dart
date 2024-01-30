import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:gide/core/models/store_model.dart';
import 'package:gide/core/models/user_model.dart';
import 'package:gide/core/services/auth_service.dart';
import 'package:gide/core/services/store_service.dart';
import 'package:gide/core/services/user_service.dart';
import 'package:gide/core/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class CreateStore extends StatefulWidget {
  const CreateStore({ Key? key }) : super(key: key);

  @override
  State<CreateStore> createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  String name = "";
  String description = "";

  double? lat = null;
  double? lng = null;

  String? path = null;
  String? fileName = null;

  final geo = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    final StorageService storage = StorageService(); 

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTextField("Name of store...", (value) {
                  setState(() {
                    name = value;
                  });
                }, false),
                _buildTextFormField("Description", (value) {
                  setState(() {
                    description = value;
                  });
                }),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: _buildTextField("Latitude", 
                          (value) {
                            setState(() {
                              try {
                                lat = double.parse(value);
                              } catch (e) {
                                lat = null;
                              }
                            });
                          }, 
                          true
                        ),
                      )
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: _buildTextField("Longitude", 
                          (value) {
                            setState(() {
                              try {
                                lng = double.parse(value);
                              } catch (e) {
                                lng = null;
                              }
                            });
                          }, 
                          true
                        ),
                      )
                    ),
                  ],
                ),
                path != null ? Expanded(child: Image.file(File(path!))) : Container(),
                ElevatedButton(
                  onPressed: () async {
                    final results = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.image,
                      // allowedExtensions: ['png', 'jpeg']
                    );

                    if (results == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No image selected..."))
                      );

                      return;
                    }

                    setState(() {
                      path = results.files.single.path!;
                      fileName = results.files.single.name;
                    });
                  }, 
                  child: Text("Upload image")
                ),
                ElevatedButton(
                  onPressed: () {
                    _createStore();
                  }, 
                  child: Text("Create store")
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget _buildTextField(String placeholderText, Function onChange, bool numOnly) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        onChanged:(value) {
          onChange(value);
        },
        inputFormatters: numOnly ? [
          FilteringTextInputFormatter(RegExp(r'(^\-?\d*\.?\d*)'), allow: true)
        ] : [],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5.5),
          ),
          hintText: placeholderText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 206, 206, 206)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextFormField(String placeholderText, Function onChange) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        onChanged:(value) {
          onChange(value);
        },
        expands: true,
        maxLines: null,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5.5),
          ),
          hintText: placeholderText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 206, 206, 206)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  void _createStore() async {
    final StorageService storage = StorageService(); 

    if (lat != null && lng != null && path != null && fileName != null && name.isNotEmpty && description.isNotEmpty) {
      storage.uploadFile(path!, fileName!)
                      .then((value) => print("Done"));

      final imageDownloadLink = await storage.downloadURL(fileName!);

      Store store = Store(
        id: const Uuid().v4(),
        name: name,
        description: description,
        ownerId: AuthenticationService.getCurrentUser()!.uid,
        coverImageLink: imageDownloadLink,
        location: geo.point(latitude: lat!, longitude: lng!),
        announcements: const [],
        items: const [],
        lastModified: Timestamp.now()
      );

      StoreSerice.updateStore(store);

      User currUser = AuthenticationService.userInfo!;
      User tempUser = User(
        id: currUser.id, 
        username: currUser.username, 
        credits: currUser.credits, 
        favoriteStores: currUser.favoriteStores,
        storeId: store.id,
        lastModified: Timestamp.now()
      );

      UserService.updateUser(tempUser);

      Navigator.of(context).pop();

      return;
    }

    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: const Text("Whoops!"),
        content: Text("Missing information..."),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: Text("Ok"))
        ],
      ),
      barrierDismissible: true
    );
  }
}