extension BigIntConvert on num {
  BigInt toBigUnsigned() => BigInt.from(this).toUnsigned(64);
  BigInt toBigSigned() => BigInt.from(this).toSigned(64);

  String toHex() => BigInt.from(this).toUnsigned(64).toRadixString(16);
}
