import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

const String jsonContentType = 'application/json';

///
/// This class contain the Comman methods of API
///
class ApiManager {
  ///
  /// This method is used for call API for the `GET` method, need to pass API Url endpoint
  ///
  Future<dynamic> httpGet(
    String url, {
    bool isLoaderShow = true,
    bool isErrorSnackShow = false,
    Function(String)? responseMsg,
  }) async {
    try {
      ///
      /// Make get method api call
      ///
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 120));

      ///
      /// Handle response and errors
      ///
      var responseJson = _returnResponse(response, isShow: isErrorSnackShow);
      var resJson = json.decode(response.body.toString());
      responseMsg = (_) {
        resJson['message'];
      };
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } finally {
      if (isLoaderShow) {
        EasyLoading.dismiss();
      }
    }
  }

  dynamic _returnResponse(
    http.Response response, {
    bool isShow = false,
  }) {
    // if (isLoaderShow) {
    //     EasyLoading.dismiss();
    //   }
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw BadRequestException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
