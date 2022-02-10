
import 'dart:io';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class SeeInternalDocument extends StatefulWidget {

  final String path;
  final String title;

  const SeeInternalDocument({Key key, this.path, this.title}) : super(key: key);

  @override
  _SeeInternalDocumentPageState createState() => _SeeInternalDocumentPageState(
     this.path,
     this.title,
  );
}

class _SeeInternalDocumentPageState extends State<SeeInternalDocument> {

  _SeeInternalDocumentPageState(
    this._path,
    this._title,
  );

  String _path;
  String _title;

   @override
  void initState() {
    super.initState();
     _path = widget.path;
     _title = widget.title;
  }

  @override
  Widget build(BuildContext context) {

    return PDFViewerScaffold( //view PDF
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(_title,
              style:  customStyleLetterSpace(Colors.white, 8, FontWeight.w700, 0.33)),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.print,
                      //color: Colors.red
                      color: Theme.of(context).accentColor
                  ),
                  onPressed: () {

                    printDocument();
                    //currentFile.writeAsBytes(bytes);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share,
                      //color: Colors.red
                      color: Theme.of(context).accentColor
                  ),
                  onPressed: () {

                    shareDocument();
                    //currentFile.writeAsBytes(bytes);
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.times, color: Theme.of(context).accentColor,),
                  onPressed: (){Navigator.of(context).pop();},
                )],
        ),
        path: _path
    );
  }

    void shareDocument() async {
      File file = File(_path);
      await Printing.sharePdf(bytes: await file.readAsBytes(), filename: _title);
    }
    void printDocument() async {
      File file = File(_path);
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => file.readAsBytes()
      );
    }
  }
