import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_connect/wc_utils/relay_auth/relay_auth.dart';

import 'mock_data.dart';

void main() {
  group('Relay Auth', () {
    late String publicKey, privateKey;
    setUp(() async {
      final keyPair =
          await generateKeyPair(Uint8List.fromList(hex.decode(TEST_SEED)));
      publicKey = keyPair.publicKey;
      privateKey = keyPair.privateKey;
    });
    test('should generate random ed25519 key pair', () async {
      final randomKeyPair = await generateKeyPair();
      expect(randomKeyPair.publicKeyBytes.length, 32);
      expect(randomKeyPair.privateKeyBytes.length, 64);
    });
    test('should generate same ed25519 key pair', () {
      expect(publicKey, EXPECTED_PUBLIC_KEY);
      expect(privateKey, EXPECTED_SECRET_KEY);
    });
    test("encode and decode issuer", () {
      final iss = encodeIss(Uint8List.fromList(hex.decode(publicKey)));
      expect(iss, EXPECTED_ISS);
      final decodedPublicKey = hex.encode(decodeIss(iss));
      expect(decodedPublicKey, publicKey);
    });
    test("encode and decode data", () async {
      final data = utf8.decode(encodeData(EXPECTED_DECODED));
      expect(data, EXPECTED_DATA);
    });
    test("sign and verify JWT", () async {
      final seed = hex.decode(TEST_SEED);
      final keyPair = await generateKeyPair(Uint8List.fromList(seed));
      final sub = TEST_SUBJECT;
      final aud = TEST_AUDIENCE;
      final ttl = TEST_TTL;
      // injected issued at for deterministic jwt
      final iat = TEST_IAT;
      final jwt = await signJWT(
        sub: sub,
        aud: aud,
        ttl: ttl,
        keyPair: keyPair,
        iat: iat,
      );
      expect(jwt, EXPECTED_JWT);
      final verified = await verifyJWT(jwt);
      expect(verified, true);
      // final decoded = didJWT.decodeJWT(jwt);
      // chai.expect(decoded).to.eql(EXPECTED_DECODED);

      // FIXME: currently errors with 'Unknown file extension ".ts"'
      // const resolver = new Resolver(KeyDIDResolver.getResolver());
      // const response = await didJWT.verifyJWT(jwt, { resolver });
      // // eslint-disable-next-line
      // console.log("response", response);
    });
  });
}