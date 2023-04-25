import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant
{

  static Future<dynamic> receiveRequest(String url) async
  {
    http.Response httpResponse = await http.get(Uri.parse(url));

    try
    {

      if(httpResponse.statusCode == 200)
      {
        //successfull response

        String responseData = httpResponse.body; //json response data

        var decodedResponseData = jsonDecode(responseData);

        return decodedResponseData;
      }

      else
      {
        return "Some error occurred. Please try again";
      }

    }

    catch(exp)
    {
      return "Some error occurred. Please try again";
    }

  }
}