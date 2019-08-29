// Copyright (c) 2014-2018, The Monero Project
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import OscillateComponents.Clipboard 1.0
import "../version.js" as Version
import "../components" as OscillateComponents
import "." 1.0


Rectangle {
    id: page
    property bool viewOnly: false
    property int keysHeight: mainLayout.height + 100 * scaleRatio

    color: "transparent"

    Clipboard { id: clipboard }
    ColumnLayout {
        id: mainLayout

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right

        anchors.margins: (isMobile)? 17 * scaleRatio : 20 * scaleRatio
        anchors.topMargin: 40 * scaleRatio

        spacing: 30 * scaleRatio
		    property int qrCodeSize: 220 * scaleRatio
        Layout.fillWidth: true

        OscillateComponents.WarningBox {
            text: qsTr("WARNING: Do not reuse your Oscillate keys on another fork, UNLESS this fork has key reuse mitigations built in. Doing so will harm your privacy.") + translationManager.emptyString
        }

        //! Manage wallet
        ColumnLayout {
            Layout.fillWidth: true

            OscillateComponents.Label {
                Layout.fillWidth: true
                fontSize: 22 * scaleRatio
                Layout.topMargin: 10 * scaleRatio
                text: qsTr("Mnemonic seed") + translationManager.emptyString
            }
            Rectangle {
                Layout.fillWidth: true
                height: 2 * scaleRatio
                color: OscillateComponents.Style.dividerColor
                opacity: OscillateComponents.Style.dividerOpacity
                Layout.bottomMargin: 10 * scaleRatio
            }

            OscillateComponents.WarningBox {
                text: qsTr("WARNING: Copying your seed to clipboard can expose you to malicious software, which may record your seed and steal your Oscillate. Please write down your seed manually.") + translationManager.emptyString
            }

            OscillateComponents.LineEditMulti {
                visible: !viewOnlyQRCode.visible
                id: seedText
                spacing: 0
                copyButton: true
                addressValidation: false
                readOnly: true
                wrapMode: Text.WordWrap
                fontColor: "white"
            }
        }

        ColumnLayout {
            Layout.fillWidth: true

            OscillateComponents.Label {
                Layout.fillWidth: true
                fontSize: 22 * scaleRatio
                Layout.topMargin: 10 * scaleRatio
                text: qsTr("Keys") + translationManager.emptyString
            }
            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: OscillateComponents.Style.dividerColor
                opacity: OscillateComponents.Style.dividerOpacity
                Layout.bottomMargin: 10 * scaleRatio
            }
            OscillateComponents.LineEdit {
		            visible: !viewOnlyQRCode.visible
                Layout.fillWidth: true
                id: secretViewKey
                readOnly: true
                copyButton: true
                labelText: qsTr("Secret view key") + translationManager.emptyString
                fontSize: 16 * scaleRatio
            }
            OscillateComponents.LineEdit {
                Layout.fillWidth: true
                Layout.topMargin: 25 * scaleRatio
                id: publicViewKey
                readOnly: true
                copyButton: true
                labelText: qsTr("Public view key") + translationManager.emptyString
                fontSize: 16 * scaleRatio
            }
            OscillateComponents.LineEdit {
                visible: !viewOnlyQRCode.visible
                Layout.fillWidth: true
                Layout.topMargin: 25 * scaleRatio
                id: secretSpendKey
                readOnly: true
                copyButton: true
                labelText: qsTr("Secret spend key") + translationManager.emptyString
                fontSize: 16 * scaleRatio
            }
            OscillateComponents.LineEdit {
                visible: !viewOnlyQRCode.visible
                Layout.fillWidth: true
                Layout.topMargin: 25 * scaleRatio
                id: publicSpendKey
                readOnly: true
                copyButton: true
                labelText: qsTr("Public spend key") + translationManager.emptyString
                fontSize: 16 * scaleRatio
            }
        }

        ColumnLayout {
            Layout.fillWidth: true

            OscillateComponents.Label {
                Layout.fillWidth: true
                fontSize: 22 * scaleRatio
                Layout.topMargin: 10 * scaleRatio
                text: qsTr("Export wallet") + translationManager.emptyString
            }
            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: OscillateComponents.Style.dividerColor
                opacity: OscillateComponents.Style.dividerOpacity
                Layout.bottomMargin: 10 * scaleRatio
            }

            ColumnLayout {

                OscillateComponents.RadioButton {
                    id: showFullQr
                    enabled: !this.checked
                    checked: fullWalletQRCode.visible
                    text: qsTr("Spendable Wallet") + translationManager.emptyString
                    onClicked: {
                        viewOnlyQRCode.visible = false
                        showViewOnlyQr.checked = false
                    }
                }
                OscillateComponents.RadioButton {
                    enabled: !this.checked
                    id: showViewOnlyQr
                    checked: viewOnlyQRCode.visible
                    text: qsTr("View Only Wallet") + translationManager.emptyString
                    onClicked: {
                        viewOnlyQRCode.visible = true
                        showFullQr.checked = false
                    }
                }
                Layout.bottomMargin: 30 * scaleRatio
            }

            Image {
                visible: !viewOnlyQRCode.visible
                id: fullWalletQRCode
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                Layout.maximumWidth: mainLayout.qrCodeSize
                Layout.preferredHeight: width
                smooth: false
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onPressAndHold: qrFileDialog.open()
                }
            }

            Image {
                visible: false
                id: viewOnlyQRCode
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                Layout.maximumWidth: mainLayout.qrCodeSize
                Layout.preferredHeight: width
                smooth: false
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onPressAndHold: qrFileDialog.open()
                }
            }

            Text {
                Layout.fillWidth: true
                font.bold: true
                font.pixelSize: 16 * scaleRatio
                color: OscillateComponents.Style.defaultFontColor
                text: (viewOnlyQRCode.visible) ? qsTr("View Only Wallet") + translationManager.emptyString : qsTr("Spendable Wallet") + translationManager.emptyString
                horizontalAlignment: Text.AlignHCenter
            }
        }

        MessageDialog {
            id: receivePageDialog
            standardButtons: StandardButton.Ok
        }
    }

    // fires on every page load
    function onPageCompleted() {
        console.log("keys page loaded");
        secretViewKey.text = currentWallet.secretViewKey
        publicViewKey.text = currentWallet.publicViewKey
        secretSpendKey.text = !currentWallet.viewOnly ? currentWallet.secretSpendKey : ""
        publicSpendKey.text = currentWallet.publicSpendKey

        seedText.text = currentWallet.seed

        if(typeof currentWallet != "undefined") {
            viewOnlyQRCode.source = "image://qrcode/oscillate_wallet:" + currentWallet.address(0, 0) + "?view_key="+currentWallet.secretViewKey+"&height="+currentWallet.walletCreationHeight
            fullWalletQRCode.source = viewOnlyQRCode.source +"&spend_key="+currentWallet.secretSpendKey

            if(currentWallet.viewOnly) {
                viewOnlyQRCode.visible = true
                showFullQr.visible = false
                showViewOnlyQr.visible = false
                seedText.text = qsTr("(View Only Wallet -  No mnemonic seed available)") + translationManager.emptyString
            }
        }
    }

    // fires only once
    Component.onCompleted: {

    }
}
