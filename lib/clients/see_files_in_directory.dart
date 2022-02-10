
import 'dart:io';
import 'package:ball_on_a_budget_planner/clients/see_internal_document.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class SeeDirectoryFiles extends StatefulWidget {

  final String targetDirectory;
  final String title;

  const SeeDirectoryFiles({Key key, this.targetDirectory, this.title}) : super(key: key);

  @override
  _SeeDirectoryFilesPageState createState() => _SeeDirectoryFilesPageState(
     this.targetDirectory,
     this.title,
  );
}

class _SeeDirectoryFilesPageState extends State<SeeDirectoryFiles> {

  _SeeDirectoryFilesPageState(
    this._targetDirectory,
    this._title,
  );

  String _targetDirectory;
  String _title;

  var files;

   @override
  void initState() {
     getFiles();
    super.initState();
     _targetDirectory = widget.targetDirectory;
     _title = widget.title;
  }

  void getFiles() async { //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    String root;
    if(_targetDirectory == null){
      root =  storageInfo[0].rootDir;
    }else{
      root = _targetDirectory;
    }
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"], //optional, to filter files, list only pdf files
        sortedBy: FileManagerSorting.Date
    );
    setState(() {}); //update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(_title,
              style:  customStyleLetterSpace(Colors.white, 14, FontWeight.w700, 0.33)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.times, color: Theme.of(context).accentColor,),
              onPressed: (){Navigator.of(context).pop();},
            )],
        ),
        body: files == null? Text("Searching Files"):
        ListView.builder(  //if file/folder list is grabbed, then show here
          itemCount: files?.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
                child:ListTile(
                  title: Text(files[index].path.split('/').last),
                  leading: Icon(Icons.picture_as_pdf),
                  trailing: Icon(Icons.arrow_forward, color: Colors.redAccent,),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return
                        SeeInternalDocument(
                            path:files[index].path.toString(),
                            title:files[index].path.split('/').last
                        );
                      //open viewPDF page on click
                    }));
                  },
                )
            );
          },
        )
    );

  }
}