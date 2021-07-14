import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:archive/archive.dart';

void download(
  List<int> bytes, {
  String downloadName,
}) {
  // Encode our file in base64
  final _base64 = base64Encode(bytes);
  // Create the link with the file
  final anchor =
      html.AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
        ..target = 'blank';
  // add the name
  if (downloadName != null) {
    anchor.download = downloadName;
  }
  // trigger download
  html.document.body.append(anchor);
  anchor.click();
  anchor.remove();
  return;
}

List<int> addFilesToZip(String result, String fileName) {
  // String jsonEncoded = jsonEncode(list);
  List<int> utf8encoded = utf8.encode(result);
  ArchiveFile processedData =
      new ArchiveFile(fileName, utf8encoded.length, utf8encoded);
  Archive zipArchive = new Archive();
  zipArchive.addFile(processedData);
  // add text file
  // add plot
  List<int> zipInBytes = new ZipEncoder().encode(zipArchive);
  return zipInBytes;
}
