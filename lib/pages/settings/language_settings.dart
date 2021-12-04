
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

enum Language {french, english}

class LanguageSettingsPage extends StatefulWidget {
  @override
  _LanguageSettingsPageState createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
   var _language;
   String intialLanguge;
   
   @override
  void initState() {
    intialLanguge = 'fr';
    super.initState();
    switch (intialLanguge) {
      case 'fr':
        _language = Language.french;
        break;

      case 'en':
        _language = Language.english;
        break;

      default:
        break;
    }
  }

  _changeLanguage(int index) {
    switch (index) {
      case 0:
        _language = Language.french;
     
        break;

      case 1:
        _language = Language.english;

        break;

    }
    context.setLocale(EasyLocalization.of(context).supportedLocales[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     
      body: SingleChildScrollView(
        child: Column(
          children: [
             RadioListTile(
              value: Language.french,
              onChanged: (value) => _changeLanguage(0),
              groupValue: _language,
              title: Text('french'.tr(), style: customStyle(Colors.white, 16, FontWeight.bold),),
            ),
            Divider(
              height: 0.5,
              indent: 10,
              endIndent: 10,
            ),
            RadioListTile(
              value: Language.english,
              onChanged: (value) => _changeLanguage(1),
              groupValue: _language,
              title: Text('english'.tr(), style: customStyle(Colors.white, 16, FontWeight.bold),),
            ),
          ],
        ),
      ),
      
      
    );
  }
}