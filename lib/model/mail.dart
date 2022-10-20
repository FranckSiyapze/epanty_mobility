import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void sendMail(String reciever, String name) async {
  String username = 'epantymobility@gmail.com';
  String password = 'epantymobility22';

  final smtpServer = gmailSaslXoauth2(username, password);

  final message = Message()
    ..from = Address(username, 'Epanty Mobility')
    ..recipients.add(reciever)
    ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    ..subject = 'Nouveau trajet avec Epanty Mobility ${DateTime.now()}'
    ..text =
        'Bonjour, ce message est pour vous informer que votre ami ${name} a commencé à utiliser Epanty Mobility.'
    ..html = "<h1>Bonjour, ce message est pour vous informer</h1>\n"
        "<p>que votre ami ${name} a commencé à utiliser Epanty Mobility.</p>";

  var connection = PersistentConnection(smtpServer);
  await connection.send(message);
  print(message);
  await connection.close();
}

Future<void> send(String reciever, String name, BuildContext context) async {
  var body = "<h1>Bonjour, ce message est pour vous informer</h1>\n"
      "<p>que votre ami ${name} a commencé à utiliser Epanty Mobility.</p>";
  var body2 = "\n----------------------------------------------------------------------------\n";
  var body3 = "<h1>Hello, this message is to inform you</h1>\n"
      "<p>that your friend ${name} has started using Epanty Mobility.</p>";
  final Email email = Email(
    body: body+body2+body3,
    subject: "Nouveau trajet avec Epanty Mobility ${DateTime.now()}",
    recipients: [reciever],
    isHTML: true,
  );

  String platformResponse;

  try {
    await FlutterEmailSender.send(email);
    platformResponse = 'success';
  } catch (error) {
    print(error);
    platformResponse = error.toString();
  }

  //if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(platformResponse),
    ),
  );
}
