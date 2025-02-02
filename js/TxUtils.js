function destinationsToAmount(destinations){
    // Gets amount from destinations line
    // input: "20.000000000000: 9tLGyK277MnYrDc7Vzi6TB1pJvstFoviziFwsqQNFbwA9rvg5RxYVYjEezFKDjvDHgAzTELJhJHVx6JAaWZKeVqSUZkXeKk"
    // returns: 20.000000000000
    return destinations.split(" ")[0].split(":")[0];
}

function destinationsToAddress(destinations){
    var address = destinations.split(" ")[1];
    if(address === undefined) return ""
    return address;
}

function addressTruncate(address, range){
    if(typeof(address) === "undefined") return;
    if(typeof(range) === "undefined") range = 8;
    return address.substring(0, range) + "..." + address.substring(address.length-range);
}

function check256(str, length) {
    if (str.length != length)
        return false;
    for (var i = 0; i < length; ++i) {
        if (str[i] >= '0' && str[i] <= '9')
            continue;
        if (str[i] >= 'a' && str[i] <= 'z')
            continue;
        if (str[i] >= 'A' && str[i] <= 'Z')
            continue;
        return false;
    }
    return true;
}

function checkAddress(address, testnet) {
  return walletManager.addressValid(address, testnet)
}

function checkTxID(txid) {
    return check256(txid, 64)
}

function checkSignature(signature) {
    if (signature.indexOf("OutProofV") === 0) {
        if ((signature.length - 10) % 132 != 0)
            return false;
        return check256(signature, signature.length);
    } else if (signature.indexOf("InProofV") === 0) {
        if ((signature.length - 9) % 132 != 0)
            return false;
        return check256(signature, signature.length);
    } else if (signature.indexOf("SpendProofV") === 0) {
        if ((signature.length - 12) % 88 != 0)
            return false;
        return check256(signature, signature.length);
    }
    return false;
}

function isValidOpenAliasAddress(address) {
    address = address.trim()
    var dot = address.indexOf('.')
    if (dot < 0)
        return false
    // we can get an awful lot of valid domains, including non ASCII chars... accept anything
    return true
}

function makeQRCodeString(addr, amount) {
    var ARQ_URI_SCHEME = "oscillate:"
    var ARQ_AMOUNT = "tx_amount"
    var qrCodeString =""
    qrCodeString += (ARQ_URI_SCHEME + addr)
    if (amount !== undefined && amount !== ""){
      qrCodeString += ("?" + ARQ_AMOUNT + "=" + amount)
    }
    return qrCodeString
}
