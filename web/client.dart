// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Client to note_server.dart.
// Use note_taker.html to run this script.

import 'dart:html';

String note;

HttpRequest request;
String url = 'http://127.0.0.1:4042';
List arr = ["", "Cick Here To Get A Quote!"];

main() {
  InputElement ele1 = makeEle(1);
  getQuote("");
  querySelector("#${ele1.id}").onClick.listen((Event e) => getQuote(ele1.id));
}

InputElement makeEle(int x){
  InputElement ele = document.getElementsByClassName("button${x}")[0];
  ele.setAttribute("id", "button1");
  ele.value = arr[x];
  return ele;
}

void getQuote(String s){
  request = new HttpRequest();
  request.onReadyStateChange.listen(onData);

  request.open('POST', url);
  request.send('{"getQuote":"${s}"}');
}

void gotQuote(String s){
   querySelector("#quote").innerHtml = "<p>"+ s +"<\p>";
   arr = s.split("; ");

   querySelector("#quote").innerHtml = "<p>\""+ arr[1].substring(7) +"\"<\p>";
   querySelector("#author").innerHtml = "<p> - "+ arr[0].substring(8) +"<\p>";
}

void onData(_) {
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
     gotQuote(request.responseText);
  } else if (request.readyState == HttpRequest.DONE && request.status == 0) {
    // Status is 0...most likely the server isn't running.
    print('No server');
  }
}
