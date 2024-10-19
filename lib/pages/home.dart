import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goner/components/snackbar_custom.dart';
import 'package:goner/handlers/api_handler.dart';
import 'package:goner/pages/uploaded_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  

  String? _fileName;
  String? _filePath;

  final TextEditingController _cTitle = TextEditingController();
  final TextEditingController _cDescription = TextEditingController();
  final TextEditingController _cTimeValue = TextEditingController(text: '1');

  String _expirationSelected = 'hours';
  final List<String> expirations = ['hours', 'days', 'weeks', 'months'];

  Future<String?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _filePath = result.files.single.path;
      _fileName = _filePath!.substring(_filePath!.lastIndexOf("/") + 1, _filePath!.length);

      setState(() {});
      return _filePath;
    }
    return null;
  }

  void applyRotine() async {
    Map<String, String> data = {};
    if(_filePath == null){
      return;
    }
    
    if (_cTitle.text.isNotEmpty) {
      data["title"] = _cTitle.text;
    }

    if (_cDescription.text.isNotEmpty) {
      data["description"] = _cDescription.text;
    }

    if (_cTimeValue.text.isNotEmpty) {

      int value = int.parse(_cTimeValue.text);
      if (_expirationSelected == 'months' && value > 12) {
        SnackBarCustom.showSnackBar(context, "Can't be more than 12 months", alertType: "yellow");
        return;
      } else if(_expirationSelected == 'weeks' && value > 52){
        SnackBarCustom.showSnackBar(context, "Can't be more than 52 weeks", alertType: "yellow");
        return;
      } else if(_expirationSelected == 'days' && value > 365){
        SnackBarCustom.showSnackBar(context, "Can't be more than 365 days", alertType: "yellow");
        return;
      } else if(_expirationSelected == 'hours' && value > 8760){
        SnackBarCustom.showSnackBar(context, "Can't be more than 8760 hours", alertType: "yellow");
        return;
      }

      

      data["expires"] = _cTimeValue.text + _expirationSelected.substring(0, 1);
            
      if(data["expires"]!.contains('m')){ // Replacing m by M, API requirement.
        data["expires"] = data["expires"]!.replaceFirst('m',"M");        
      }
      
    } else {
      SnackBarCustom.showSnackBar(context, "Expiration time empty", alertType: "red");
    }

    SnackBarCustom.showSnackBar(context, "Uploading...", alertType: "blue", seconds: 10);
    
    if (_filePath != null) {
      ApiHandler().uploadFile(_filePath!, data).then((value) {
          
          if(value.isEmpty){            
            SnackBarCustom.showSnackBar(context, "Empty", alertType: "red");  
            return;
          }          

          SnackBarCustom.showSnackBar(context, "Done", alertType: "green");
          _cleanFields();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadedPage(data: value)),
          );
          
        },
      ).onError(
        (error, stackTrace) {
          SnackBarCustom.showSnackBar(context, "Fail", alertType: "red");          
        },
      );
    }
  }

  Widget _labelFieldWidget(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20),
    );
  }

  void _cleanFields() {
    _fileName = null;
    _filePath = null;
    _cTimeValue.text = '1';
    _cTitle.clear();
    _cDescription.clear();
    _expirationSelected = 'hours';
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('Goner')),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenSize.height,
          child: Column(
            children: [
              const Center(),
              const SizedBox(
                height: 15,
              ),

              // select file label
              Row(
                children: [
                  SizedBox(
                    width: (screenSize.width * .1) / 2,
                  ),
                  _labelFieldWidget("Select File:"),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              // file selector
              GestureDetector(
                onTap: () {
                  _pickFile();
                },
                child: Container(
                  decoration: const BoxDecoration(color: Color.fromARGB(255, 41, 41, 41), borderRadius: BorderRadius.all(Radius.circular(5))),
                  height: 80,
                  width: screenSize.width * .9,
                  child: _fileName == null
                      ? const Icon(Icons.file_upload, size: 25)
                      : Center(
                          child: Text(
                          _fileName!,
                          style: const TextStyle(fontSize: 18),
                        )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Expires label
              Row(
                children: [
                  SizedBox(
                    width: (screenSize.width * .1) / 2,
                  ),
                  _labelFieldWidget("Expiration time:"),
                ],
              ),

              // expires time

              SizedBox(
                width: (screenSize.width * .9),
                child: Row(
                  children: [
                    Container(
                      width: screenSize.width / 2,
                      decoration: const BoxDecoration(color: Color.fromARGB(255, 36, 36, 36), borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: TextFormField(
                        decoration: const InputDecoration(contentPadding: EdgeInsets.only(left: 10)),
                        controller: _cTimeValue,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Container(
                      height: 65,
                      width: 100,
                      padding: const EdgeInsets.only(top: 10, left: 11),
                      decoration: BoxDecoration(border: Border.all(width: .5, color: Colors.white, style: BorderStyle.solid), borderRadius: const BorderRadius.all(Radius.circular(3))),
                      child: DropdownButton<String>(
                        underline: const SizedBox(),
                        style: const TextStyle(fontSize: 17),
                        value: _expirationSelected,
                        items: expirations.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _expirationSelected = value!;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),

              // Title label
              Row(
                children: [
                  SizedBox(
                    width: (screenSize.width * .1) / 2,
                  ),
                  _labelFieldWidget("Title: (optional)"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              // title textfield
              Container(
                width: screenSize.width * .9,
                decoration: const BoxDecoration(color: Color.fromARGB(255, 36, 36, 36), borderRadius: BorderRadius.all(Radius.circular(4))),
                child: TextFormField(
                  decoration: const InputDecoration(contentPadding: EdgeInsets.only(left: 10)),
                  controller: _cTitle,
                ),
              ),
              const SizedBox(
                height: 35,
              ),

              // description label
              Row(
                children: [
                  SizedBox(
                    width: (screenSize.width * .1) / 2,
                  ),
                  _labelFieldWidget("Description: (optional)"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              // description textfield
              Container(
                decoration: const BoxDecoration(color: Color.fromARGB(255, 36, 36, 36), borderRadius: BorderRadius.all(Radius.circular(4))),
                width: screenSize.width * .9,
                child: TextFormField(
                  decoration: const InputDecoration(contentPadding: EdgeInsets.only(left: 10)),
                  controller: _cDescription,
                ),
              ),
              const SizedBox(
                height: 50,
              ),              
              
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          applyRotine();                          
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 43, 43, 53), minimumSize: Size(MediaQuery.of(context).size.height / 2, 50)),
                        child: const Text(
                          'Upload',
                          style: TextStyle(fontSize: 20, letterSpacing: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            
            ],
          ),
        ),
      ),
     
    );
  }
}
