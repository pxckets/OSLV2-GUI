// Copyright (c) 2018-2019, The Oscillate Network
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

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import ArqmaComponents.Wallet 1.0
import ArqmaComponents.NetworkType 1.0
import ArqmaComponents.Clipboard 1.0
import "components" as ArqmaComponents

Rectangle {
    id: panel

    property alias unlockedBalanceText: unlockedBalanceText.text
    property alias unlockedBalanceVisible: unlockedBalanceText.visible
    property alias unlockedBalanceLabelVisible: unlockedBalanceLabel.visible
    property alias balanceLabelText: balanceLabel.text
    property alias balanceText: balanceText.text
    property alias networkStatus : networkStatus
    property alias progressBar : progressBar
    property alias daemonProgressBar : daemonProgressBar
    property alias minutesToUnlockTxt: unlockedBalanceLabel.text
    property int titleBarHeight: 50
    property string copyValue: ""
    Clipboard { id: clipboard }

    signal historyClicked()
    signal transferClicked()
    signal receiveClicked()
    signal txkeyClicked()
    signal reserveClicked()
    signal sharedringdbClicked()
    signal settingsClicked()
    signal addressBookClicked()
    signal miningClicked()
    signal signClicked()
    signal keysClicked()
    signal merchantClicked()
    signal accountClicked()

    function selectItem(pos) {
        menuColumn.previousButton.checked = false
        if(pos === "History") menuColumn.previousButton = historyButton
        else if(pos === "Transfer") menuColumn.previousButton = transferButton
        else if(pos === "Receive")  menuColumn.previousButton = receiveButton
        else if(pos === "Merchant")  menuColumn.previousButton = merchantButton
        else if(pos === "AddressBook") menuColumn.previousButton = addressBookButton
        else if(pos === "Mining") menuColumn.previousButton = miningButton
        else if(pos === "TxKey")  menuColumn.previousButton = txkeyButton
        else if(pos === "ReserveProof")  menuColumn.previousButton = reserveButton
        else if(pos === "SharedRingDB")  menuColumn.previousButton = sharedringdbButton
        else if(pos === "Sign") menuColumn.previousButton = signButton
        else if(pos === "Settings") menuColumn.previousButton = settingsButton
        else if(pos === "Advanced") menuColumn.previousButton = advancedButton
        else if(pos === "Keys") menuColumn.previousButton = keysButton
        else if(pos === "Account") menuColumn.previousButton = accountButton
        menuColumn.previousButton.checked = true
    }

    width: isMobile ? appWindow.width : 300
    color: "transparent"
    anchors.bottom: parent.bottom
    anchors.top: parent.top

    Image {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: panel.height
        source: "images/leftPanelBg.jpg"
        z: 1
    }

    // card with Oscillate Card
    Column {
        visible: !isMobile
        z: 2
        id: column1
        height: 210
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: (persistentSettings.customDecorations)? 50 : 0

        RowLayout {
            visible: !isMobile
            Item {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                height: 490 * scaleRatio
                width: 260 * scaleRatio

                Image {
                    width: 260; height: 170
                    fillMode: Image.PreserveAspectFit
                    source: "images/card-background.png"
                }

                Text {
                    id: testnetLabel
                    visible: persistentSettings.nettype != NetworkType.MAINNET
                    text: (persistentSettings.nettype == NetworkType.TESTNET ? qsTr("Testnet") : qsTr("Stagenet")) + translationManager.emptyString
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 192
                    font.bold: true
                    font.pixelSize: 12
                    color: "#FF0000"
                }

                Text {
                    id: viewOnlyLabel
                    visible: viewOnly
                    text: qsTr("View Only") + translationManager.emptyString
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    anchors.right: testnetLabel.visible ? testnetLabel.left : parent.right
                    anchors.rightMargin: 8
                    font.pixelSize: 12
                    font.bold: true
                    color: "#FF0000"
                }

                Rectangle {
                    visible: !isMobile
                    height: (logoutImage.height + 8) * scaleRatio
                    width: (logoutImage.width + 8) * scaleRatio
                    color: "transparent"
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.top: parent.top
                    anchors.topMargin: 25

                    Image {
                        id: logoutImage
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 16 * scaleRatio
                        width: 13 * scaleRatio
                        source: "../images/logout.png"
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            middlePanel.addressBookView.clearFields();
                            middlePanel.transferView.clearFields();
                            middlePanel.receiveView.clearFields();
                            appWindow.showWizard();
                        }
                    }
                }
            }

            Item {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                height: 490 * scaleRatio
                width: 50 * scaleRatio

                Text {
                    visible: !isMobile
                    id: balanceText
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 76
                    font.family: ArqmaComponents.Style.fontRegular.name
                    color: "#FFFFFF"
                    text: "N/A"
                    // dynamically adjust text size
                    font.pixelSize: {
                        var digits = text.split('.')[0].length
                        var defaultSize = 22;
                        if(digits > 2) {
                            return defaultSize - 1.1*digits
                        }
                        return defaultSize;
                    }

                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            parent.color = ArqmaComponents.Style.heroBlue
                        }
                        onExited: {
                            parent.color = "white"
                        }
                        onClicked: {
                            console.log("Copied to clipboard");
                            clipboard.setText(parent.text);
                            appWindow.showStatusMessage(qsTr("Copied to clipboard"),3)
                        }
                    }
                }

                Text {
                    id: unlockedBalanceText
                    visible: true
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 126
                    font.family: ArqmaComponents.Style.fontRegular.name
                    color: "#FFFFFF"
                    text: "N/A"
                    // dynamically adjust text size
                    font.pixelSize: {
                        var digits = text.split('.')[0].length
                        var defaultSize = 20;
                        if(digits > 3) {
                            return defaultSize - 0.6*digits
                        }
                        return defaultSize;
                    }

                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            parent.color = ArqmaComponents.Style.lightBlue
                        }
                        onExited: {
                            parent.color = "white"
                        }
                        onClicked: {
                            console.log("Copied to clipboard");
                            clipboard.setText(parent.text);
                            appWindow.showStatusMessage(qsTr("Copied to clipboard"),3)
                        }
                    }
                }

                ArqmaComponents.Label {
                    id: unlockedBalanceLabel
                    visible: true
                    text: qsTr("Unlocked balance") + translationManager.emptyString
                    fontSize: 14
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 110
                }

                ArqmaComponents.Label {
                    visible: !isMobile
                    id: balanceLabel
                    text: qsTr("Balance") + translationManager.emptyString
                    fontSize: 14
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 60
                    elide: Text.ElideRight
                    textWidth: 238
                }
                Item { //separator
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                }
            }
        }
    }

    Rectangle {
        id: menuRect
        z: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: isMobile ? parent.top : column1.bottom
        color: "transparent"


        Flickable {
            id:flicker
            contentHeight: menuColumn.height
            anchors.top: parent.top
            anchors.bottom: networkStatus.top
            width: parent.width
            clip: true

        Column {
            id: menuColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            clip: true
            property var previousButton: transferButton

            // top border
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

            // ------------- Account tab ---------------
            ArqmaComponents.MenuButton {
                id: accountButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Account") + translationManager.emptyString
                symbol: qsTr("T") + translationManager.emptyString
                dotColor: "#44AAFF"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = accountButton
                    panel.accountClicked()
                }
            }

            Rectangle {
                visible: accountButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

            // ------------- Transfer tab ---------------
            ArqmaComponents.MenuButton {
                id: transferButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Send") + translationManager.emptyString
                symbol: qsTr("S") + translationManager.emptyString
                dotColor: "#308c24"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = transferButton
                    panel.transferClicked()
                }
            }

            Rectangle {
                visible: transferButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

            // ------------- AddressBook tab ---------------

            ArqmaComponents.MenuButton {
                id: addressBookButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Address book") + translationManager.emptyString
                symbol: qsTr("B") + translationManager.emptyString
                dotColor: "#b88406"
                under: transferButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = addressBookButton
                    panel.addressBookClicked()
                }
            }

            Rectangle {
                visible: addressBookButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

            // ------------- Receive tab ---------------
            ArqmaComponents.MenuButton {
                id: receiveButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Receive") + translationManager.emptyString
                symbol: qsTr("R") + translationManager.emptyString
                dotColor: "#b900ca"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = receiveButton
                    panel.receiveClicked()
                }
            }
            Rectangle {
                visible: receiveButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

            // ------------- Merchant tab ---------------

            ArqmaComponents.MenuButton {
                id: merchantButton
                visible: appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Merchant") + translationManager.emptyString
                symbol: qsTr("U") + translationManager.emptyString
                dotColor: "#FF4F41"
                under: receiveButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = merchantButton
                    panel.merchantClicked()
                }
            }

            Rectangle {
                visible: merchantButton.present && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

            // ------------- History tab ---------------

            ArqmaComponents.MenuButton {
                id: historyButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("History") + translationManager.emptyString
                symbol: qsTr("H") + translationManager.emptyString
                dotColor: "#7c92ff"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = historyButton
                    panel.historyClicked()
                }
            }
            Rectangle {
                visible: historyButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

            // ------------- Advanced tab ---------------
            ArqmaComponents.MenuButton {
                id: advancedButton
                visible: appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Advanced") + translationManager.emptyString
                symbol: qsTr("D") + translationManager.emptyString
                dotColor: "#e00000"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = advancedButton
                }
            }
            Rectangle {
                visible: advancedButton.present && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

            // ------------- Mining tab ---------------
            ArqmaComponents.MenuButton {
                id: miningButton
                visible: !isAndroid && !isIOS && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Mining") + translationManager.emptyString
                symbol: qsTr("M") + translationManager.emptyString
                dotColor: "#e00000"
                under: advancedButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = miningButton
                    panel.miningClicked()
                }
            }

            Rectangle {
                visible: miningButton.present && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: miningButton.checked || settingsButton.checked ? "#E16B6B" : "#860000"
                height: 1
            }
            // ------------- TxKey tab ---------------
            ArqmaComponents.MenuButton {
                id: txkeyButton
                visible: appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Prove/check") + translationManager.emptyString
                symbol: qsTr("K") + translationManager.emptyString
                dotColor: "#e00000"
                under: advancedButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = txkeyButton
                    panel.txkeyClicked()
                }
            }
            Rectangle {
                visible: txkeyButton.present && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

            // ----------- Reserve Proofs tab -------------
            ArqmaComponents.MenuButton {
                id: reserveButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Reserve Proofs") + translationManager.emptyString
                symbol: qsTr("W") + translationManager.emptyString
                dotColor: "#e00000"
                under: advancedButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = reserveButton
                    panel.reserveClicked()
                }
            }
            Rectangle {
                visible: reserveButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

            // ------------- Shared RingDB tab ---------------
            ArqmaComponents.MenuButton {
                id: sharedringdbButton
                visible: appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Shared RingDB") + translationManager.emptyString
                symbol: qsTr("G") + translationManager.emptyString
                dotColor: "#e00000"
                under: advancedButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = sharedringdbButton
                    panel.sharedringdbClicked()
                }
            }
            Rectangle {
                visible: sharedringdbButton.present && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }


            // ------------- Sign/verify tab ---------------
            ArqmaComponents.MenuButton {
                id: signButton
                visible: appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Sign/verify") + translationManager.emptyString
                symbol: qsTr("I") + translationManager.emptyString
                dotColor: "#e00000"
                under: advancedButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = signButton
                    panel.signClicked()
                }
            }
            Rectangle {
                visible: signButton.present && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }
            // ------------- Settings tab ---------------
            ArqmaComponents.MenuButton {
                id: settingsButton
                visible: appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Settings") + translationManager.emptyString
                symbol: qsTr("E") + translationManager.emptyString
                dotColor: "#98ff33"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = settingsButton
                    panel.settingsClicked()
                }
            }
            Rectangle {
                visible: settingsButton.present && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }
            // ------------- Sign/verify tab ---------------
            ArqmaComponents.MenuButton {
                id: keysButton
                visible: appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Seed & Keys") + translationManager.emptyString
                symbol: qsTr("Y") + translationManager.emptyString
                dotColor: "#98ff33"
                under: settingsButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = keysButton
                    panel.keysClicked()
                }
            }
            Rectangle {
                visible: settingsButton.present && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#313131"
                height: 1
            }

        } // Column

        } // Flickable

        Rectangle {
            id: separator
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.bottom: networkStatus.top;
            height: 10 * scaleRatio
            color: "transparent"
        }

        ArqmaComponents.NetworkStatusItem {
            id: networkStatus
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.bottom: progressBar.visible ? progressBar.top : networkStatusSpacer.top;
            connected: Wallet.ConnectionStatus_Disconnected
            height: 54 * scaleRatio
        }

        Rectangle {
            id: networkStatusSpacer
            visible: !progressBar.visible
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 10 * scaleRatio
            color: "transparent"
        }

        ArqmaComponents.ProgressBar {
            id: progressBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: daemonProgressBar.top
            height: 48 * scaleRatio
            syncType: qsTr("Wallet")
            visible: networkStatus.connected
        }

        ArqmaComponents.ProgressBar {
            id: daemonProgressBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            syncType: qsTr("Daemon")
            visible: networkStatus.connected
            height: 62 * scaleRatio
        }
    } // menuRect



    // indicate disabled state
//    Desaturate {
//        anchors.fill: parent
//        source: parent
//        desaturation: panel.enabled ? 0.0 : 1.0
//    }


}
