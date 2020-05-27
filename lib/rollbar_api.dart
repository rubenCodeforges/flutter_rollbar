import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_rollbar/rollbar_types.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class RollbarApi {
  final http.Client _client = http.Client();
  
  /// @message should contain body as a key and value
  Future<http.Response> sendReport({
    @required String accessToken,
    @required Map message,
    @required List<RollbarTelemetry> telemetry,
    Map clientData,
    RollbarPerson person,
    String environment,
    String uuid = null
  }) {
    var dataPayload = {
      'environment': environment,
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'framework': 'flutter',
      'language': 'dart',
      'body': {
        'message': message,
        'telemetry': telemetry.map((item) => item.toJson()).toList(),
      },
      'person': person?.toJson(),
      'client': clientData,
      'notifier': {
        'name': 'flutter_rollbar',
        'version': '0.0.1+1',
      }
    };
    if (uuid != null) {
      dataPayload['uuid'] = uuid;
    }
    print(dataPayload['uuid']);
    return _client.post(
      'https://api.rollbar.com/api/1/item/',
      body: json.encode(
        {
          'access_token': accessToken,
          'data': dataPayload
        },
      ),
    );
  }
}
