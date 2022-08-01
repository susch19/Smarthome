// // ignore_for_file: implementation_imports

// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:signalr_core/src/hub_protocol.dart';
// import 'package:signalr_core/src/logger.dart';
// import 'package:signalr_core/src/text_message_format.dart';
// import 'package:signalr_core/src/transport.dart';
// import 'package:signalr_core/src/utils.dart';
// // import "package:pointycastle/export.dart";
// import 'package:encrypt/encrypt.dart';

// const String jsonHubProtocolName = 'smarthome';

// /// Implements the JSON Hub Protocol.
// class SmarthomeProtocol implements HubProtocol {
//   @override
//   String get name => jsonHubProtocolName;

//   @override
//   int get version => 1;

//   @override
//   TransferFormat get transferFormat => TransferFormat.binary;

//   // Uint8List aesCbcEncrypt(final Uint8List key, final Uint8List iv, final Uint8List paddedPlaintext) {
//   //   assert([128, 192, 256].contains(key.length * 8));
//   //   assert(128 == iv.length * 8);
//   //   assert(128 == paddedPlaintext.length * 8);

//   //   // Create a CBC block cipher with AES, and initialize with key and IV

//   //   final cbc = CBCBlockCipher(AESEngine())..init(true, ParametersWithIV(KeyParameter(key), iv)); // true=encrypt

//   //   // Encrypt the plaintext block-by-block

//   //   final cipherText = Uint8List(paddedPlaintext.length); // allocate space

//   //   var offset = 0;
//   //   while (offset < paddedPlaintext.length) {
//   //     offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
//   //   }
//   //   assert(offset == paddedPlaintext.length);

//   //   return cipherText;
//   // }

//   // Uint8List aesCbcDecrypt(final Uint8List key, final Uint8List iv, final Uint8List cipherText) {
//   //   assert([128, 192, 256].contains(key.length * 8));
//   //   assert(128 == iv.length * 8);
//   //   assert(128 == cipherText.length * 8);

//   //   // Create a CBC block cipher with AES, and initialize with key and IV

//   //   final cbc = CBCBlockCipher(AESEngine())..init(false, ParametersWithIV(KeyParameter(key), iv)); // false=decrypt

//   //   // Decrypt the cipherText block-by-block

//   //   final paddedPlainText = Uint8List(cipherText.length); // allocate space

//   //   var offset = 0;
//   //   while (offset < cipherText.length) {
//   //     offset += cbc.processBlock(cipherText, offset, paddedPlainText, offset);
//   //   }
//   //   assert(offset == cipherText.length);

//   //   return paddedPlainText;
//   // }

//   /// Creates an array of [HubMessage] objects from the specified serialized representation.
//   @override
//   List<HubMessage?> parseMessages(final dynamic input, final Logging? logging) {
//     // Only JsonContent is allowed.
//     if (input is! Uint8List) {
//       throw Exception('Invalid input for JSON hub protocol. Expected a string.');
//     }

//     final hubMessages = <HubMessage?>[];

//     // ignore: unnecessary_null_comparison
//     if (input == null) {
//       return hubMessages;
//     }

//     final key = Key.fromUtf8('my 32 length key................');
//     final iv = IV.fromUtf8("das123ist456ein7");
//     final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

//     // final p = Padding("PKCS7");
//     // p.init();
//     // p.addPadding(input, oldLen);
//     final jsonInput = encrypter.decrypt(Encrypted(input), iv: iv);

//     // Parse the messages
//     final messages = TextMessageFormat.parse(jsonInput);
//     for (final message in messages) {
//       final jsonData = json.decode(message);
//       final messageType = _getMessageTypeFromJson(jsonData as Map<String, dynamic>);
//       HubMessage? parsedMessage;

//       switch (messageType) {
//         case MessageType.invocation:
//           parsedMessage = InvocationMessageExtensions.fromJson(jsonData);
//           _isInvocationMessage(parsedMessage as InvocationMessage);
//           break;
//         case MessageType.streamItem:
//           parsedMessage = StreamItemMessageExtensions.fromJson(jsonData);
//           _isStreamItemMessage(parsedMessage as StreamItemMessage);
//           break;
//         case MessageType.completion:
//           parsedMessage = CompletionMessageExtensions.fromJson(jsonData);
//           _isCompletionMessage(parsedMessage as CompletionMessage);
//           break;
//         case MessageType.ping:
//           parsedMessage = PingMessageExtensions.fromJson(jsonData);
//           // Single value, no need to validate
//           break;
//         case MessageType.close:
//           parsedMessage = CloseMessageExtensions.fromJson(jsonData);
//           // All optional values, no need to validate
//           break;
//         default:
//           // Future protocol changes can add message types, old clients can ignore them
//           logging!(LogLevel.information, 'Unknown message type \'' + parsedMessage!.type.toString() + '\' ignored.');
//           continue;
//       }
//       hubMessages.add(parsedMessage);
//     }

//     return hubMessages;
//   }

//   /// Writes the specified [HubMessage] to a string and returns it.
//   @override
//   ByteBuffer? writeMessage(final HubMessage message) {
//     switch (message.type) {
//       case MessageType.undefined:
//         break;
//       case MessageType.invocation:
//         return encrypt(TextMessageFormat.write(json.encode((message as InvocationMessage).toJson())));
//       case MessageType.streamItem:
//         return encrypt(TextMessageFormat.write(json.encode((message as StreamItemMessage).toJson())));
//       case MessageType.completion:
//         return encrypt(TextMessageFormat.write(json.encode((message as CompletionMessage).toJson())));
//       case MessageType.streamInvocation:
//         return encrypt(TextMessageFormat.write(json.encode((message as StreamInvocationMessage).toJson())));
//       case MessageType.cancelInvocation:
//         return encrypt(TextMessageFormat.write(json.encode((message as CancelInvocationMessage).toJson())));
//       case MessageType.ping:
//         return encrypt(TextMessageFormat.write(json.encode((message as PingMessage).toJson())));
//       case MessageType.close:
//         return encrypt(TextMessageFormat.write(json.encode((message as CloseMessage).toJson())));
//       default:
//         break;
//     }
//     return null;
//   }

//   ByteBuffer? encrypt(final String input) {
//     // return Uint8List.fromList(utf8.encode(input)).buffer;

//     final key = Key.fromUtf8('my 32 length key................');
//     final iv = IV.fromUtf8("das123ist456ein7");
//     final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
//     return encrypter.encrypt(input, iv: iv).bytes.buffer;
//   }

//   static MessageType _getMessageTypeFromJson(final Map<String, dynamic> json) {
//     switch (json['type'] as int?) {
//       case 0:
//         return MessageType.undefined;
//       case 1:
//         return MessageType.invocation;
//       case 2:
//         return MessageType.streamItem;
//       case 3:
//         return MessageType.completion;
//       case 4:
//         return MessageType.streamInvocation;
//       case 5:
//         return MessageType.cancelInvocation;
//       case 6:
//         return MessageType.ping;
//       case 7:
//         return MessageType.close;
//       default:
//         return MessageType.undefined;
//     }
//   }

//   void _isInvocationMessage(final InvocationMessage message) {
//     _assertNotEmptyString(message.target, 'Invalid payload for Invocation message.');

//     if (message.invocationId != null) {
//       _assertNotEmptyString(message.target, 'Invalid payload for Invocation message.');
//     }
//   }

//   void _isStreamItemMessage(final StreamItemMessage message) {
//     _assertNotEmptyString(message.invocationId, 'Invalid payload for StreamItem message.');

//     if (message.item == null) {
//       throw Exception('Invalid payload for StreamItem message.');
//     }
//   }

//   void _isCompletionMessage(final CompletionMessage message) {
//     if ((message.result == null) && (message.error != null)) {
//       _assertNotEmptyString(message.error, 'Invalid payload for Completion message.');
//     }

//     _assertNotEmptyString(message.invocationId, 'Invalid payload for Completion message.');
//   }

//   void _assertNotEmptyString(final dynamic value, final String errorMessage) {
//     if ((value is String == false) || (value as String).isEmpty) {
//       throw Exception(errorMessage);
//     }
//   }
// }

// extension InvocationMessageExtensions on InvocationMessage {
//   static InvocationMessage fromJson(final Map<String, dynamic> json) {
//     return InvocationMessage(
//       target: json['target'] as String?,
//       arguments: (json['arguments'] as List?)?.map((final item) => item as Object).toList(),
//       headers: json['headers'] as Map<String, String>?,
//       invocationId: json['invocationId'] as String?,
//       streamIds: json['streamIds'] as List<String>?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type.value,
//       if (invocationId != null) 'invocationId': invocationId,
//       'target': target,
//       'arguments': arguments ?? [],
//       if (streamIds != null) 'streamIds': streamIds
//     };
//   }
// }

// extension StreamInvocationMessageExtensions on StreamInvocationMessage {
//   Map<String, dynamic> toJson() {
//     return {
//       'type': type.value,
//       'invocationId': invocationId,
//       'target': target,
//       'arguments': arguments,
//       'streamIds': streamIds
//     };
//   }
// }

// extension StreamItemMessageExtensions on StreamItemMessage {
//   static StreamItemMessage fromJson(final Map<String, dynamic> json) {
//     return StreamItemMessage(
//       item: json['item'] as dynamic,
//       headers: json['headers'] as Map<String, String>?,
//       invocationId: json['invocationId'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type.value,
//       'item': item,
//       'invocationId': invocationId,
//     };
//   }
// }

// extension CancelInvocationMessageExtensions on CancelInvocationMessage {
//   Map<String, dynamic> toJson() {
//     return {
//       'type': type.value,
//       'invocationId': invocationId,
//     };
//   }
// }

// extension CompletionMessageExtensions on CompletionMessage {
//   static CompletionMessage fromJson(final Map<String, dynamic> json) {
//     return CompletionMessage(
//       result: json['result'],
//       error: json['error'] as String?,
//       headers: json['headers'] as Map<String, String>?,
//       invocationId: json['invocationId'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type.value,
//       'invocationId': invocationId,
//       'result': result,
//       'error': error,
//     };
//   }
// }

// extension PingMessageExtensions on PingMessage {
//   static PingMessage fromJson(final Map<String, dynamic> json) {
//     return PingMessage();
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type.value,
//     };
//   }
// }

// extension CloseMessageExtensions on CloseMessage {
//   static CloseMessage fromJson(final Map<String, dynamic> json) {
//     return CloseMessage(error: json['error'] as String?);
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type.value,
//       'error': error,
//     };
//   }
// }

// ignore_for_file: prefer_is_not_operator

import 'dart:convert';
import 'dart:typed_data';

import 'package:logging/logging.dart';

import 'package:signalr_netcore/errors.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:signalr_netcore/text_message_format.dart';
import 'package:signalr_netcore/utils.dart';
import 'package:encrypt/encrypt.dart';
import 'package:smarthome/cloud/app_cloud_configuration.dart';

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
      final len = _getLengthOfBytes(input);
      final iv = IV(input.sublist(lastIndex + 4, 20));
      final inputWithoutLen = input.sublist(lastIndex + 20, len + 20);
      lastIndex = len + 20;
      final jsonInput = encrypter.decrypt(Encrypted(inputWithoutLen), iv: iv);
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
      final _headers1 = Map<String, String>.from(jsonData);
      final headers = MessageHeaders();
      _headers1.forEach((final key, final value) {
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
    final res = encrypt(TextMessageFormat.write(json.encode(jsonObj)), iv);

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

  Uint8List encrypt(final String input, final IV iv) {
    if (!enableEncSnd) return Uint8List.fromList(utf8.encode(input));

    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    return encrypter.encrypt(input, iv: iv).bytes;
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
