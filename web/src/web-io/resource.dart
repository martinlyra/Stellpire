import 'dart:html';
import 'dart:async';

class Resource
{
  String content;
  String path;
  String fileName;

  Resource()
  {

  }

  static Future<Resource> fetch(String url, {int timeoutMs: 5000}) async
  {
    var res = new Resource();
    res.path = url;
    res.fileName = url.split("/").last;

    var httpResponse = await HttpRequest.request(url)
        .timeout(Duration(milliseconds: timeoutMs));

    res.content = httpResponse.responseText;

    return res;
  }
}