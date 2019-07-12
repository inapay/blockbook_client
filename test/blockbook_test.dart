import 'dart:io';

import 'package:test/test.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:blockbook/blockbook.dart';

void main() {
  MockWebServer server;
  Blockbook blockbook;

  setUp(() async {
    server = MockWebServer();
    await server.start();
    blockbook = Blockbook(server.url);
  });

  tearDown(() {
    server.shutdown();
  });

  group("http API calls", () {
    test('status', () async {
      server.enqueue(body: File("test/files/status.json").readAsStringSync());

      var status = await blockbook.status();

      expect(status["blockbook"]["coin"], "Bitcoin");
    });

    test('blockHash', () async {
      server.enqueue(
          body: File("test/files/blockHash.json").readAsStringSync());

      var blockHash = await blockbook.blockHash(500000);

      expect(server.takeRequest().uri.path, endsWith("500000"));
      expect(blockHash,
          "00000000000000000024fb37364cbf81fd49cc2d51c09c75c35433c3a1945d04");
    });

    test('transaction', () async {
      server.enqueue(
          body: File("test/files/transaction.json").readAsStringSync());

      var tx = await blockbook.transaction(
          "4a4c48638ffd14fca86c663ce6bfb6edd7dbe8538284cd23bad5c21a498d086e");

      expect(
          server.takeRequest().uri.path,
          endsWith(
              "4a4c48638ffd14fca86c663ce6bfb6edd7dbe8538284cd23bad5c21a498d086e"));
      expect(tx["txid"],
          "4a4c48638ffd14fca86c663ce6bfb6edd7dbe8538284cd23bad5c21a498d086e");
    });

    test('transactionSpecific', () async {
      server.enqueue(
          body: File("test/files/transactionSpecific.json").readAsStringSync());

      var tx = await blockbook.transactionSpecific(
          "4a4c48638ffd14fca86c663ce6bfb6edd7dbe8538284cd23bad5c21a498d086e");

      expect(
          server.takeRequest().uri.path,
          endsWith(
              "tx-specific/4a4c48638ffd14fca86c663ce6bfb6edd7dbe8538284cd23bad5c21a498d086e"));
      expect(tx["txid"],
          "4a4c48638ffd14fca86c663ce6bfb6edd7dbe8538284cd23bad5c21a498d086e");
    });

    test('address', () async {
      server.enqueue(body: File("test/files/address.json").readAsStringSync());

      var address =
          await blockbook.address("bc1qzq4dsuku95evf89sulryzkx7uasnkh4zwwt6q4");

      expect(server.takeRequest().uri.path,
          endsWith("bc1qzq4dsuku95evf89sulryzkx7uasnkh4zwwt6q4"));
      expect(address["address"], "bc1qzq4dsuku95evf89sulryzkx7uasnkh4zwwt6q4");
    });

    test('xpub', () async {
      server.enqueue(body: File("test/files/xpub.json").readAsStringSync());

      var xpub = await blockbook.xpub(
          "xpub6CUGRUonZSQ4TWtTMmzXdrXDtypWKiKrhko4egpiMZbpiaQL2jkwSB1icqYh2cfDfVxdx4df189oLKnC5fSwqPfgyP3hooxujYzAu3fDVmz");

      expect(
          server.takeRequest().uri.path,
          endsWith(
              "xpub6CUGRUonZSQ4TWtTMmzXdrXDtypWKiKrhko4egpiMZbpiaQL2jkwSB1icqYh2cfDfVxdx4df189oLKnC5fSwqPfgyP3hooxujYzAu3fDVmz"));
      expect(xpub["address"],
          "xpub6CUGRUonZSQ4TWtTMmzXdrXDtypWKiKrhko4egpiMZbpiaQL2jkwSB1icqYh2cfDfVxdx4df189oLKnC5fSwqPfgyP3hooxujYzAu3fDVmz");
    });

    test('utxo', () async {
      server.enqueue(body: File("test/files/utxo.json").readAsStringSync());

      var utxo = await blockbook.utxo("1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa");

      expect(server.takeRequest().uri.path,
          endsWith("1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"));
      expect(utxo[0]["txid"],
          "7a0fc95fdc459bee2f5bc7156ff23dcc84b6dbaadf34d9d2fc79b01179c1a6bf");
    });

    test('block (with hash)', () async {
      server.enqueue(body: File("test/files/block.json").readAsStringSync());

      var block = await blockbook.block(
          "00000000000000000024fb37364cbf81fd49cc2d51c09c75c35433c3a1945d04");

      expect(
          server.takeRequest().uri.path,
          endsWith(
              "00000000000000000024fb37364cbf81fd49cc2d51c09c75c35433c3a1945d04"));
      expect(block["hash"],
          "00000000000000000024fb37364cbf81fd49cc2d51c09c75c35433c3a1945d04");
    });

    test('block (with height)', () async {
      server.enqueue(body: File("test/files/block.json").readAsStringSync());

      var block = await blockbook.block(500000);

      expect(server.takeRequest().uri.path, endsWith("500000"));
      expect(block["height"], 500000);
    });

    test('sendTransaction', () {}, skip: 'todo');
  });

  group("websocket calls", () {}, skip: 'todo');
}
