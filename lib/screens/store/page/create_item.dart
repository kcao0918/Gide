//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:gide/core/models/item_model.dart';
import 'package:gide/core/models/store_model.dart';
import 'package:gide/core/models/user_model.dart';
import 'package:gide/core/services/auth_service.dart';
import 'package:gide/core/services/storage_service.dart';
import 'package:gide/core/services/store_service.dart';
import 'package:gide/core/services/user_service.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class CreateItem extends StatefulWidget {
  final Store store;
  const CreateItem({ Key? key, required this.store }) : super(key: key);

  @override
  State<CreateItem> createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> {
  String name = "";
  String description = "";

  String? path = null;
  String? fileName = null;

  final geo = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTextField("Name of item...", (value) {
                  setState(() {
                    name = value;
                  });
                }, false),
                _buildTextFormField("Description", (value) {
                  setState(() {
                    description = value;
                  });
                }),
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
                    child: const Text("Upload image")
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                    onPressed: () {
                      _createItem();
                    },
                    child: const Text("Create item")
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


  void _createItem() async{
    final StorageService storage = StorageService();
    //Store store = Store.fromFirestore(snapshot.data as DocumentSnapshot<Map<String, dynamic>>, null);

    if (name.isNotEmpty && description.isNotEmpty) {
      storage.uploadFile(path!, fileName!).then((value) => print('Done'));

      final imageDownloadLink = await storage.downloadURL(fileName!);

      List<Item> items = widget.store.items != null ? [...widget.store.items!] : [];

      Item item = Item(
        name: name,
        description: description,
        imageLink: imageDownloadLink,
        storeId: widget.store.id
      );

      items.add(item);
      widget.store.items!.add(item);

      Store tempStore = Store(
          id: widget.store.id,
          name: widget.store.name,
          description: widget.store.description,
          ownerId: widget.store.ownerId,
          coverImageLink: widget.store.coverImageLink,
          location: widget.store.location,
          announcements: widget.store.announcements,
          items: items,
          lastModified: Timestamp.now()
      );

      StoreSerice.updateStore(tempStore); 

      Navigator.of(context).pop();

      return;
    }

    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: const Text("Whoops!"),
        content: const Text("Missing information..."),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: const Text("Ok"))
        ],
      ),
      barrierDismissible: true
    );
  }
}