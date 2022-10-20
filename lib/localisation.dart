import 'dart:async';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    /// English texts
    'en': {
      'localeCode': 'en',
      'signIn': 'Sign In',
      'login': 'Login',
      'signUp': 'Sign Up',
      'signUpTitle': 'Sign Up',
      'userName': 'User name',
      'email': 'Email address',
      'phone': 'Phone',
      'password': 'Password',
      'oldPassword': 'Old Password',
      'newPassword': 'New Password',
      'confirmNewPassword': 'Confirm New Password',
      'confirmPassword': 'Confirm password',
      'firstName': 'First name',
      'lastName': 'Last name',
      'map':"Map",
      'informationGeneral':"General Information",
      "infostrajet":"Trip informations",
      'compte':"Account",
      "infospersonnel":"Personal Information",
      "change":"Change your information",
      "mois":"Month",
      'confidentialite':"Privacy",
      'langue':"Please choose your language",
      'langue1':"Choose your preferred language",
      'deconnexion':"Sign out",
      'abonnement':"Expired",
      'abonnementtexte':"Your instant ride numbers have expired,\n \n so be sure to re-subscribe",
      'params':"Parameters",
      'pay':"Payment",
      "change_pass":"Change your password",
      "remplir":"Fill in the form to change your password",
      "remplir_form":"Fill in the form",
      "requis":"Required",
      "short_pass":"Your password is not strong",
      "pass_not_match":"The password not match",
      "succes":"Succeed",
      "echec":"Failed",
      "email_invalid":"Invalid Email",
      "save":"Save",
      "confirm":"Confirm",
      "invalide":"Invalid",
      "retirer":"Remove specials characters",
      "trop_long":"Name is to long",
      "modify":"To change any information, simply change the value in the field.",
      "start":"Start the trip",
      "immatriculation":"Vehicle registration",
      "state":"State, region or province",
      "paiment":"Payment - Method of payment",
      "syst":"Set to System Language"

    },

    /// French texts
    'fr': {
      'localeCode': 'fr',
      'signIn': 'Se Connecter',
      'login': 'Connexion',
      'signUp': 'Créer mon compte',
      'signUpTitle': 'Création\nde compte',
      'userName': 'Nom d\'utilisateur',
      'email': 'Addresse mail',
      'phone': 'Téléphone',
      'password': 'Mot de passe',
      'oldPassword': 'Ancien mot de passe',
      'newPassword': 'Nouveau mot de passe',
      'confirmNewPassword': 'Confirmer nouveau mot de passe',
      'confirmPassword': 'Confirmation mot de passe',
      'firstName': 'Nom',
      'lastName': 'Prénom',
      'map':"Carte",
      'informationGeneral':"Information Général",
      'compte':"Compte",
      "infospersonnel":"Informations Personnel",
      "infostrajet":"Informations du trajet",
      "change":"Changer vos informations",
      "mois":"Mois",
      'confidentialite':"Confidentialité",
      'langue':"Veuillez choisir votre langue",
      'langue1':"Choisir la langue de préférence",
      'deconnexion':"Deconnexion",
      'abonnement':"Abonnement Expiré",
      'abonnementtexte':"Vos nombre de trajet instantané sont expirer, \n\n Veiller vous réabonnez",
      'params':"Paramètres",
      'pay':"Paiement",
      "change_pass":"Changer votre mot de passe",
      "remplir":"Remplissez le formulaire pour changer le mot de passe",
      "remplir_form":"Veillez remplir le formulaire",
      "requis":"Champs requis",
      "short_pass":"Mot de passe trop court",
      "pass_not_match":"Mot de passe ne corresponds pas",
      "succes":"Opération réussi",
      "echec":"Operation échoué",
      "email_invalid":"Email Invalide",
      "save":"Sauvegarder les informations",
      "confirm":"Confirmer",
      "invalide":"Invalide",
      "retirer":"Retirez les caractère spéciaux",
      "trop_long":"Nom trop long",
      "modify":"Pour changer une information, modifiez la tous simplement la valeur dans le champ.",
      "start":"Commencé le trajet",
      "immatriculation":"Immatriculation du véhicule",
      "state":"État, région ou province",
      "paiment":"Paiement - Mode de paiement",
      "syst":"Régler à la Langue du Système"

    },
  };

  static List<String> languages() => _localizedValues.keys.toList();

  String get syst {
    return _localizedValues[locale.languageCode]!['syst']!;
  }
  String get paiment {
    return _localizedValues[locale.languageCode]!['paiment']!;
  }
  String get change_pass {
    return _localizedValues[locale.languageCode]!['change_pass']!;
  }
  String get state {
    return _localizedValues[locale.languageCode]!['state']!;
  }
  String get immatriculation {
    return _localizedValues[locale.languageCode]!['immatriculation']!;
  }
  String get start {
    return _localizedValues[locale.languageCode]!['start']!;
  }
  String get invalide {
    return _localizedValues[locale.languageCode]!['invalide']!;
  }
  String get phone {
    return _localizedValues[locale.languageCode]!['phone']!;
  }
  String get infostrajet {
    return _localizedValues[locale.languageCode]!['infostrajet']!;
  }
  String get modify {
    return _localizedValues[locale.languageCode]!['modify']!;
  }
  String get trop_long {
    return _localizedValues[locale.languageCode]!['trop_long']!;
  }
  String get retirer {
    return _localizedValues[locale.languageCode]!['retirer']!;
  }
  String get confirm {
    return _localizedValues[locale.languageCode]!['confirm']!;
  }
  String get save {
    return _localizedValues[locale.languageCode]!['save']!;
  }
  String get email_invalid {
    return _localizedValues[locale.languageCode]!['email_invalid']!;
  }
  String get email {
    return _localizedValues[locale.languageCode]!['email']!;
  }
  String get echec {
    return _localizedValues[locale.languageCode]!['echec']!;
  }
  String get succes {
    return _localizedValues[locale.languageCode]!['succes']!;
  }
  String get confirmNewPassword {
    return _localizedValues[locale.languageCode]!['confirmNewPassword']!;
  }
  String get pass_not_match {
    return _localizedValues[locale.languageCode]!['pass_not_match']!;
  }

  String get oldPassword {
    return _localizedValues[locale.languageCode]!['oldPassword']!;
  }
  String get short_pass {
    return _localizedValues[locale.languageCode]!['short_pass']!;
  }
  String get requis {
    return _localizedValues[locale.languageCode]!['requis']!;
  }
  String get remplir_form {
    return _localizedValues[locale.languageCode]!['remplir_form']!;
  }
  String get remplir {
    return _localizedValues[locale.languageCode]!['remplir']!;
  }
  String get pay {
    return _localizedValues[locale.languageCode]!['pay']!;
  }
  String get params {
    return _localizedValues[locale.languageCode]!['params']!;
  }
  String get newPassword {
    return _localizedValues[locale.languageCode]!['newPassword']!;
  }
  String get abonnementtexte {
    return _localizedValues[locale.languageCode]!['abonnementtexte']!;
  }
  String get abonnement {
    return _localizedValues[locale.languageCode]!['abonnement']!;
  }
  String get deconnexion {
    return _localizedValues[locale.languageCode]!['deconnexion']!;
  }
  String get langue {
    return _localizedValues[locale.languageCode]!['langue']!;
  }
  String get langue1 {
    return _localizedValues[locale.languageCode]!['langue1']!;
  }
  String get confidentialite {
    return _localizedValues[locale.languageCode]!['confidentialite']!;
  }
  String get mois {
    return _localizedValues[locale.languageCode]!['mois']!;
  }
  String get change {
    return _localizedValues[locale.languageCode]!['change']!;
  }
  String get infospersonnel {
    return _localizedValues[locale.languageCode]!['infospersonnel']!;
  }
  String get compte {
    return _localizedValues[locale.languageCode]!['compte']!;
  }
  String get localeCode {
    return _localizedValues[locale.languageCode]!['localeCode']!;
  }

  String get signIn {
    return _localizedValues[locale.languageCode]!['signIn']!;
  }

  String get login {
    return _localizedValues[locale.languageCode]!['login']!;
  }

  String get passwordTooShort {
    return _localizedValues[locale.languageCode]!['passwordTooShort']!;
  }

  String get signUp {
    return _localizedValues[locale.languageCode]!['signUp']!;
  }

  String get signUpTitle {
    return _localizedValues[locale.languageCode]!['signUpTitle']!;
  }

  String get userName {
    return _localizedValues[locale.languageCode]!['userName']!;
  }

  String get password {
    return _localizedValues[locale.languageCode]!['password']!;
  }

  String get confirmPassword {
    return _localizedValues[locale.languageCode]!['confirmPassword']!;
  }

  String get firstName {
    return _localizedValues[locale.languageCode]!['firstName']!;
  }

  String get lastName {
    return _localizedValues[locale.languageCode]!['lastName']!;
  }

  String get map {
    return _localizedValues[locale.languageCode]!['map']!;
  }

  String get informationGeneral {
    return _localizedValues[locale.languageCode]!['informationGeneral']!;
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.languages().contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
