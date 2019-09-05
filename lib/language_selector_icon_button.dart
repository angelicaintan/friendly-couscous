import 'package:flutter/material.dart';
import 'package:drleveldown/language_selector_page.dart';

// ICON BUTTON THAT NAVIGATES TO THE LANGUAGE_SELECTOR_PAGE

class LanguageSelectorIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _languageIconTapped(context);
      },
      icon: Icon(
        Icons.settings,
        color: Colors.white,
      ),
    );
  }

  _languageIconTapped(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LanguageSelectorPage(),
      ),
    );
  }
}
