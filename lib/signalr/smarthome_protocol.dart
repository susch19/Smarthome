// ignore_for_file: prefer_is_not_operator

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';

import 'package:signalr_netcore/errors.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:signalr_netcore/text_message_format.dart';
import 'package:signalr_netcore/utils.dart';
import 'package:encrypt/encrypt.dart';
import 'package:smarthome/cloud/app_cloud_configuration.dart';
import 'package:archive/archive_io.dart';

class SmarthomeProtocol implements IHubProtocol {
  // Properties

  static AppCloudConfiguration? cloudConfig;

  Key get _key => Key(cloudConfig!.keyBytes);

  @override
  String get name => "smarthome";

  @override
  int get version => 1;

  @override
  TransferFormat get transferFormat => TransferFormat.Binary;

  // Methods

  /// Creates an array of {@link @microsoft/signalr.HubMessage} objects from the specified serialized representation.
  ///
  /// A string containing the serialized representation.
  /// A logger that will be used to log messages that occur during parsing.
  ///
  @override
  List<HubMessageBase> parseMessages(final Object input, final Logger? logger) {
    // Only JsonContent is allowed.
    if (!(input is Uint8List)) {
      throw GeneralError("Invalid input for JSON hub protocol. Expected a string.");
    }

    final List<HubMessageBase> hubMessages = [];

    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    int lastIndex = 0;
    while (lastIndex < input.length) {
      final len = _getLengthOfBytes(input.sublist(lastIndex, 4));
      final iv = IV(input.sublist(lastIndex + 4, 20));

      final inputWithoutLen = input.sublist(lastIndex + 20, lastIndex + len + 20);
      lastIndex = len + 20;
      final decrypted = encrypter.decryptBytes(Encrypted(inputWithoutLen), iv: iv);

      final jsonInput = utf8.decode(gzip.decode(decrypted));

      // Parse the messages
      final messages = TextMessageFormat.parse(jsonInput);
      for (final message in messages) {
        final jsonData = json.decode(message);
        final messageType = _getMessageTypeFromJson(jsonData);
        HubMessageBase messageObj;

        switch (messageType) {
          case MessageType.Invocation:
            messageObj = _getInvocationMessageFromJson(jsonData);
            break;
          case MessageType.StreamItem:
            messageObj = _getStreamItemMessageFromJson(jsonData);
            break;
          case MessageType.Completion:
            messageObj = _getCompletionMessageFromJson(jsonData);
            break;
          case MessageType.Ping:
            messageObj = _getPingMessageFromJson(jsonData);
            break;
          case MessageType.Close:
            messageObj = _getCloseMessageFromJson(jsonData);
            break;
          default:
            // Future protocol changes can add message types, old clients can ignore them
            logger?.info("Unknown message type '$messageType' ignored.");
            continue;
        }
        hubMessages.add(messageObj);
      }
    }

    return hubMessages;
  }

  static MessageType? _getMessageTypeFromJson(final Map<String, dynamic> json) {
    return parseMessageTypeFromString(json["type"]);
  }

  static MessageHeaders? createMessageHeadersFromJson(final dynamic jsonData) {
    if (jsonData == null) {
      return null;
    } else {
      final headers1 = Map<String, String>.from(jsonData);
      final headers = MessageHeaders();
      headers1.forEach((final key, final value) {
        headers.setHeaderValue(key, value);
      });
      return headers;
    }
  }

  static InvocationMessage _getInvocationMessageFromJson(final Map<String, dynamic> jsonData) {
    final MessageHeaders? headers = createMessageHeadersFromJson(jsonData["headers"]);
    final message = InvocationMessage(
        target: jsonData["target"],
        arguments: jsonData["arguments"]?.cast<Object>().toList(),
        streamIds: (jsonData["streamIds"] == null) ? null : (List<String>.from(jsonData["streamIds"] as List<dynamic>)),
        headers: headers,
        invocationId: jsonData["invocationId"] as String?);

    _assertNotEmptyString(message.target, "Invalid payload for Invocation message.");
    if (message.invocationId != null) {
      _assertNotEmptyString(message.invocationId, "Invalid payload for Invocation message.");
    }

    return message;
  }

  static StreamItemMessage _getStreamItemMessageFromJson(final Map<String, dynamic> jsonData) {
    final MessageHeaders? headers = createMessageHeadersFromJson(jsonData["headers"]);
    final message =
        StreamItemMessage(item: jsonData["item"], headers: headers, invocationId: jsonData["invocationId"] as String?);

    _assertNotEmptyString(message.invocationId, "Invalid payload for StreamItem message.");
    if (message.item == null) {
      throw InvalidPayloadException("Invalid payload for StreamItem message.");
    }
    return message;
  }

  static CompletionMessage _getCompletionMessageFromJson(final Map<String, dynamic> jsonData) {
    final MessageHeaders? headers = createMessageHeadersFromJson(jsonData["headers"]);
    final message = CompletionMessage(
        error: jsonData["error"],
        result: jsonData["result"],
        headers: headers,
        invocationId: jsonData["invocationId"] as String?);

    if ((message.result != null) && (message.error != null)) {
      throw InvalidPayloadException("Invalid payload for Completion message.");
    }

    if ((message.result == null) && (message.error != null)) {
      _assertNotEmptyString(message.error, "Invalid payload for Completion message.");
    }

    return message;
  }

  static PingMessage _getPingMessageFromJson(final Map<String, dynamic> jsonData) {
    return PingMessage();
  }

  static CloseMessage _getCloseMessageFromJson(final Map<String, dynamic> jsonData) {
    return CloseMessage(error: jsonData["error"], allowReconnect: jsonData["allowReconnect"]);
  }

  /// Writes the specified HubMessage to a string and returns it.
  ///
  /// message: The message to write.
  /// Returns a string containing the serialized representation of the message.
  ///
  @override
  Object writeMessage(final HubMessageBase message) {
    final jsonObj = _messageAsMap(message);
    final iv = IV.fromSecureRandom(16);
    final compressed = gzip.encode(utf8.encode(TextMessageFormat.write(json.encode(jsonObj))));
    final res = encrypt(compressed, iv);

    // final compressed = gzip.encode(Uint8List.fromList([...iv.bytes, ...res]));

    // return GZipCodec().encode(Uint8List.fromList([..._getBytesOfInt(res.length), ...iv.bytes, ...res]));
    return Uint8List.fromList([..._getBytesOfInt(res.length), ...iv.bytes, ...res]);
  }

  int _getLengthOfBytes(final Uint8List list) {
    return list[0] << 24 | list[1] << 16 | list[2] << 8 | list[3] << 0;
  }

  Uint8List _getBytesOfInt(final int l) {
    int a = (l >> 24) & 0xFF;
    int b = (l >> 16) & 0xFF;
    int c = (l >> 8) & 0xFF;
    int d = (l >> 0) & 0xFF;
    return Uint8List.fromList([a, b, c, d]);
  }

  final enableEncSnd = true;

  Uint8List encrypt(final List<int> input, final IV iv) {
    if (!enableEncSnd) return Uint8List.fromList(input);

    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    return encrypter.encryptBytes(input, iv: iv).bytes;
  }

  static dynamic _messageAsMap(final dynamic message) {
    if (message == null) {
      throw GeneralError("Cannot encode message which is null.");
    }

    if (!(message is HubMessageBase)) {
      throw GeneralError("Cannot encode message of type '${message.typ}'.");
    }

    final messageType = message.type.index;

    if (message is InvocationMessage) {
      return {
        "type": messageType,
        "headers": message.headers.asMap,
        "invocationId": message.invocationId,
        "target": message.target,
        "arguments": message.arguments,
        "streamIds": message.streamIds,
      };
    }

    if (message is StreamInvocationMessage) {
      return {
        "type": messageType,
        "headers": message.headers.asMap,
        "invocationId": message.invocationId,
        "target": message.target,
        "arguments": message.arguments,
        "streamIds": message.streamIds,
      };
    }

    if (message is StreamItemMessage) {
      return {
        "type": messageType,
        "headers": message.headers.asMap,
        "invocationId": message.invocationId,
        "item": message.item
      };
    }

    if (message is CompletionMessage) {
      return {
        "type": messageType,
        "invocationId": message.invocationId,
        "headers": message.headers.asMap,
        "error": message.error,
        "result": message.result
      };
    }

    if (message is PingMessage) {
      return {"type": messageType};
    }

    if (message is CloseMessage) {
      return {"type": messageType, "error": message.error, "allowReconnect": message.allowReconnect};
    }

    if (message is CancelInvocationMessage) {
      return {"type": messageType, "invocationId": message.invocationId};
    }

    throw GeneralError("Converting '${message.type}' is not implemented.");
  }

  static void _assertNotEmptyString(final String? value, final String errorMessage) {
    if (isStringEmpty(value)) {
      throw InvalidPayloadException(errorMessage);
    }
  }
}
