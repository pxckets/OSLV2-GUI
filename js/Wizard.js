.pragma library

function updateFromQrCode(address, payment_id, amount, tx_description, recipient_name, extra_parameters) {
    // Switch to recover from keys
    recoverFromSeedMode = false
    spendKeyLine.text = ""
    viewKeyLine.text = ""
    restoreHeight.text = ""

    if(typeof extra_parameters.secret_view_key != "undefined") {
        viewKeyLine.text = extra_parameters.secret_view_key
    }
    if(typeof extra_parameters.secret_spend_key != "undefined") {
        spendKeyLine.text = extra_parameters.secret_spend_key
    }
    if(typeof extra_parameters.restore_height != "undefined") {
        restoreHeight.text = extra_parameters.restore_height
    }
    addressLine.text = address

    cameraUi.qrcode_decoded.disconnect(updateFromQrCode)

    // Check if keys are correct
    checkNextButton();
}

function switchPage(next) {
    // Android focus workaround
    releaseFocus();

    // save settings for current page;
    if (next && typeof pages[currentPage].onPageClosed !== 'undefined') {
        if (pages[currentPage].onPageClosed(settings) !== true) {
            print ("Can't go to the next page");
            return;
        };

    }
    console.log("switchpage: currentPage: ", currentPage);

    // Update prev/next button positions for mobile/desktop
    prevButton.anchors.verticalCenter = (!isMobile) ? wizard.verticalCenter : undefined
    prevButton.anchors.bottom = (isMobile) ? wizard.bottom : undefined
    nextButton.anchors.verticalCenter = (!isMobile) ? wizard.verticalCenter : undefined
    nextButton.anchors.bottom = (isMobile) ? wizard.bottom : undefined

    if (currentPage > 0 || currentPage < pages.length - 1) {
        pages[currentPage].opacity = 0
        var step_value = next ? 1 : -1
        currentPage += step_value
        pages[currentPage].opacity = 1;

        var nextButtonVisible = currentPage > 1 && currentPage < pages.length - 1
        nextButton.visible = nextButtonVisible

        if (typeof pages[currentPage].onPageOpened !== 'undefined') {
            pages[currentPage].onPageOpened(settings,next)
        }
    }
}

function createWalletPath(isIOS, folder_path,account_name){
    // Remove trailing slash - (default on windows and mac)
    if (folder_path.substring(folder_path.length -1) === "/"){
        folder_path = folder_path.substring(0,folder_path.length -1)
    }

    // Store releative path on ios.
    if(isIOS)
        folder_path = "";

    return folder_path + "/" + account_name + "/" + account_name
}

function walletPathExists(directory, filename, isIOS, walletManager) {
    if(!filename || filename === "") return false;
    if(!directory || directory === "") return false;

    // make sure directory endswith path seperator
    // @TODO: use .endswith() after Qt 5.8
    var trailing_path_sep = directory[directory.length-1];
    if(trailing_path_sep !== "/" && trailing_path_sep !== "\\")
        directory += "/"

    if(isIOS)
        var path = ArqmaAccountsDir + filename;
    else
        var path = directory + filename + "/" + filename;

    if (walletManager.walletExists(path))
        return true;
    return false;
}

function isAscii(str){
    for (var i = 0; i < str.length; i++) {
        if (str.charCodeAt(i) > 127)
            return false;
    }
    return true;
}

function tr(text) {
    return qsTr(text) + translationManager.emptyString
}

function lineBreaksToSpaces(text) {
    return text.trim().replace(/(\r\n|\n|\r)/gm, " ");
}

function usefulName(path) {
    // arbitrary "short enough" limit
    if (path.length < 32)
        return path
    return path.replace(/.*[\/\\]/, '').replace(/\.keys$/, '')
}

function checkSeed(seed) {
    console.log("Checking seed")
    var wordsArray = lineBreaksToSpaces(seed).split(" ");
    return wordsArray.length === 25 || wordsArray.length === 24
}

function restoreWalletCheckViewSpendAddress(walletmanager, nettype, viewkey, spendkey, addressline){
    var results = [];
    // addressOK
    results[0] = walletmanager.addressValid(addressline, nettype);
    // viewKeyOK
    results[1] = walletmanager.keyValid(viewkey, addressline, true, nettype);
    // spendKeyOK, Spendkey is optional
    results[2] = walletmanager.keyValid(spendkey, addressline, false, nettype);
    return results;
}

//usage: getApproximateBlockchainHeight("March 18 2016") or getApproximateBlockchainHeight("2016-11-11")
//returns estimated block height with 1 month buffer prior to requested date.
function getApproximateBlockchainHeight(_date){
    // time of Oscillate birth 2018-06-14 19:05:25 (1397818193)
    var oscillateBirthTime = 1529003125;
    var secondsPerBlockV7 = 240;
    var forkTime = 1552431155;
    // v11 fork block
    var forkBlock = 131650;
    var secondsPerBlockV11 = 120;
    // time in UTC
    var requestedTime = Math.floor(new Date(_date) / 1000);
    var approxBlockchainHeight;
    var secondsPerBlock;
    if (requestedTime < oscillateBirthTime){
        console.log("Calculated blockchain height: 0, requestedTime < oscillateBirthTime " );
        return 0;
    }
    if (requestedTime > oscillateBirthTime && requestedTime < forkTime){
        approxBlockchainHeight = Math.floor((requestedTime - oscillateBirthTime)/secondsPerBlockV7);
        console.log("Calculated blockchain height: " + approxBlockchainHeight );
        secondsPerBlock = secondsPerBlockV7;
    }
    // time is during V11
    else{
        approxBlockchainHeight =  Math.floor(forkBlock + (requestedTime - forkTime)/secondsPerBlockV11);
        console.log("Calculated blockchain height: " + approxBlockchainHeight );
        secondsPerBlock = secondsPerBlockV11;
    }
    var blocksPerMonth = 60*60*24*30/secondsPerBlock;
    if(approxBlockchainHeight - blocksPerMonth > 0){
        return approxBlockchainHeight - blocksPerMonth;
    }
    else{
        return 0;
    }
}
