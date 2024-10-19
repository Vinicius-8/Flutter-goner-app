import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goner/components/snackbar_custom.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ignore: must_be_immutable
class UploadedPage extends StatefulWidget {
  Map data;
  UploadedPage({super.key, required this.data});

  @override
  State<UploadedPage> createState() => _UploadedPageState();
}

class _UploadedPageState extends State<UploadedPage> {
  

  String formatted = '';

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }



  @override
  void initState() {
    DateTime now = DateTime.parse(widget.data["expires"]);
    var formatter = DateFormat('dd/MM/yyyy HH:mm');
    formatted = formatter.format(now);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(children: [
        
          SizedBox(height: screenSize.height / 8,),
        
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(5))
            ),        
            child: QrImageView(
                data: widget.data["link"],
                version: QrVersions.auto,
                size: 200.0,
              ),
          ),

          const SizedBox(height: 10),
          Text('Expiration: $formatted', style: const TextStyle(fontSize: 15),
            ),
          const SizedBox(height: 4),
          const Text(
              'The file will be deleted either after being downloaded once\nor at the expiration time set above.',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center
            ),
          const SizedBox( height: 90),
        

          GestureDetector(
            onTap: () {
              SnackBarCustom.showSnackBar(context, "Copied!", alertType: "blue");              
              _copyToClipboard(widget.data["link"]);
            },
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 41, 41, 41),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.data["link"], style: const TextStyle( fontSize: 20),),
                  const SizedBox(width: 20,),
                  const Icon(Icons.copy)
                ],
              ),
            ),
          )
        ],),
      ),      
    );
  }
}