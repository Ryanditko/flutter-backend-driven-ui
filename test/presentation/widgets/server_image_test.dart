import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/presentation/widgets/server_image.dart';
import 'package:flutter_test/flutter_test.dart';

/// Valid 1×1 transparent PNG for mocked HTTP responses.
final List<int> _kTinyPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get contentLength => _kTinyPng.length;

  @override
  int get statusCode => HttpStatus.ok;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.decompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable(<List<int>>[_kTinyPng]).listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  testWidgets('renders Image.network widget', (tester) async {
    final node = ComponentNode(
      type: 'image',
      props: const {
        'url': 'https://example.com/picture.png',
      },
    );

    await HttpOverrides.runZoned(
      () async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) =>
                    buildServerImage(node, context, (c) => const SizedBox()),
              ),
            ),
          ),
        );
        // loadingBuilder uses a CircularProgressIndicator until bytes decode;
        // pumpAndSettle would hang on that animation, so advance time explicitly.
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.image, isA<NetworkImage>());
        expect((image.image as NetworkImage).url, 'https://example.com/picture.png');

        imageCache.clear();
      },
      createHttpClient: (SecurityContext? _) => _MockHttpClient(),
    );
  });
}
