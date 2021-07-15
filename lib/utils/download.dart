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

List<int> addFilesToZip({Map csvFile, Map reportFile}) {
  final bytes = utf8.encode(reportFile['data']);
  final blob = html.Blob([bytes]);
  // String jsonEncoded = jsonEncode(list);
  List<int> utf8encoded = utf8.encode(csvFile['data']);
  ArchiveFile processedData =
      new ArchiveFile(csvFile['filename'], utf8encoded.length, utf8encoded);
  ArchiveFile report = ArchiveFile(reportFile['filename'], bytes.length, bytes);
  Archive zipArchive = new Archive();
  zipArchive.addFile(processedData);
  zipArchive.addFile(report);
  // add plot
  List<int> zipInBytes = new ZipEncoder().encode(zipArchive);
  return zipInBytes;
}
