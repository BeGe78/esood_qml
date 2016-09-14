/*
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
*/

import QtQuick 2.7
import QtQuick.Controls 1.2
import "."

Rectangle {
    id: rootLogin
    property string loginSwitch: "login"
    signal loginok
    width: 320
    height: 410
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    color: "white"
    transform: Scale {
        id: scaler
        origin.x: rootLogin.width / 2
        origin.y: 5
        xScale: pinchArea.m_zoom2
        yScale: pinchArea.m_zoom2
    }
    PinchArea {
        id: pinchArea
        pinch.target: rootLogin
        anchors.fill: parent
        property real m_x1: 0
        property real m_y1: 0
        property real m_y2: 5
        property real m_x2: rootLogin.width / 2
        property real m_zoom1: 1
        property real m_zoom2: 1
        property real m_max: 2
        property real m_min: 0.5

        onPinchStarted: {
            console.log("Pinch Started")
            m_x1 = scaler.origin.x
            m_y1 = scaler.origin.y
            m_x2 = pinch.startCenter.x
            m_y2 = pinch.startCenter.y
            rootLogin.x = rootLogin.x + (pinchArea.m_x1-pinchArea.m_x2)*(1-pinchArea.m_zoom1)
            rootLogin.y = rootLogin.y + (pinchArea.m_y1-pinchArea.m_y2)*(1-pinchArea.m_zoom1)
        }
        onPinchUpdated: {
            console.log("Pinch Updated")
            m_zoom1 = scaler.xScale
            var dz = pinch.scale-pinch.previousScale
            var newZoom = m_zoom1+dz
            if (newZoom <= m_max && newZoom >= m_min) {
                m_zoom2 = newZoom
            }
        }
        MouseArea {
            id: dragArea
            hoverEnabled: true
            anchors.fill: parent
            onWheel: {
                console.log("Wheel Scrolled1:", pinchArea.m_x1, pinchArea.m_y1, pinchArea.m_x2, pinchArea.m_y2, pinchArea.m_zoom1 )
                pinchArea.m_x1 = scaler.origin.x
                pinchArea.m_y1 = scaler.origin.y
                pinchArea.m_zoom1 = scaler.xScale

                pinchArea.m_x2 = rootLogin.width / 2
                pinchArea.m_y2 = 5
                console.log("Wheel Scrolled2:", pinchArea.m_x1, pinchArea.m_y1, pinchArea.m_x2, pinchArea.m_y2, pinchArea.m_zoom1 )

                var newZoom
                if (wheel.angleDelta.y > 0) {
                    newZoom = pinchArea.m_zoom1+0.1
                    if (newZoom <= pinchArea.m_max) {
                        pinchArea.m_zoom2 = newZoom
                    } else {
                        pinchArea.m_zoom2 = pinchArea.m_max
                    }
                } else {
                    newZoom = pinchArea.m_zoom1-0.1
                    if (newZoom >= pinchArea.m_min) {
                        pinchArea.m_zoom2 = newZoom
                    } else {
                        pinchArea.m_zoom2 = pinchArea.m_min
                    }
                }
                rootLogin.x = rootLogin.x + (pinchArea.m_x1-pinchArea.m_x2)*(1-pinchArea.m_zoom1)
                rootLogin.y = rootLogin.y + (pinchArea.m_y1-pinchArea.m_y2)*(1-pinchArea.m_zoom1)
            }
            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Click in child")
            }
        }
    }

    Row {
        id: emailRow
        anchors.top: parent.top
        width: parent.width
        height: emailText.height + 20
        spacing: 5
        padding: 10

        Text {
            id: emailText
            width: (emailRow.width*0.3)
            height: 40
            text: qsTr("Email:")
            font.family: "Verdana"
            font.bold: true
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 15
        }

        Rectangle {
            id: emailTextInputRectangle
            width: (emailRow.width*0.6)
            height: 40
            color: "#00000000"
            radius: 2
            border.color: "#0d0000"
            TextInput {
                id: emailTextInput
                width: emailTextInputRectangle.width
                height: 40
                text: qsTr("")
                cursorVisible: true
                verticalAlignment: TextInput.AlignVCenter
                font.pixelSize: 15
            }
        }
    }

    Row {
        id: passwordRow
        anchors.top: emailRow.bottom
        width: parent.width
        height: passwordText.height + 20
        spacing: 5
        padding: 10

        Text {
            id: passwordText
            width: (passwordRow.width*0.3)
            height: 40
            text: qsTr("Password:")
            font.family: "Verdana"
            font.bold: true
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 15
        }

        Rectangle {
            id: passwordTextInputRectangle
            width: (passwordRow.width*0.6)
            height: 40
            color: "#00000000"
            radius: 2
            border.color: "#0d0000"
            TextInput {
                id: passwordTextInput
                width: passwordTextInputRectangle.width
                height: 40
                text: qsTr("")
                passwordCharacter: qsTr("●")
                echoMode: TextInput.Password
                font.pixelSize: 12
            }
        }
    }

    Button {
        id: loginButton
        anchors.top: passwordRow.bottom
        radius: 3
        text: qsTr("Login")
        anchors.topMargin: 28
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: passwordRow.horizontalCenter
        border.width: 2
        onClicked: {
            if (rootLogin.loginSwitch == "login") {
                postSession();
            } else {
                deleteSession();
            }
        }
    }
    Text {
        id: messageText
        anchors.top: loginButton.bottom
        width: 200
        height: 100
        color: "#e21d1d"
        text: qsTr("")
        anchors.topMargin: 20
        anchors.horizontalCenterOffset: 0
        font.family: "Arial"
        textFormat: Text.RichText
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
    }

    function postSession() {
        var req = "http://localhost:3000/api/v1/sessions.json";
        var xhr = new XMLHttpRequest;
        xhr.open("POST", req, true);
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var postSessionResponse = JSON.parse(xhr.responseText);
                console.log( "Login postSessionResponse: " + xhr.responseText );
                if (xhr.status == 200) {
                    mainRect.password = passwordTextInput.text;
                    mainRect.email = emailTextInput.text;
                    mainRect.auth_token = postSessionResponse.data.auth_token;
                    console.log( "Login mainRect.auth_token " + mainRect.auth_token );
                    messageText.text = postSessionResponse.info;
                    emailTextInputRectangle.color = "#44444444";
                    passwordTextInputRectangle.color = "#44444444";
                    rootLogin.loginSwitch = "logout";
                    loginButton.text = qsTr("Logout");
                    rootLogin.loginok(); // emit signal to refresh the list
                } else {
                    messageText.text = qsTr("error Login");
                }
            }
        }
        xhr.send(JSON.stringify({user:{email:emailTextInput.text, password:passwordTextInput.text}}));
        console.log("login user JSON.stringify", JSON.stringify({user:{email:emailTextInput.text, password:passwordTextInput.text}}));
    }
    
    function deleteSession() {
        var req = "http://localhost:3000/api/v1/sessions.json";
        var xhr = new XMLHttpRequest;
        xhr.open("DELETE", req, true);
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var postSessionResponse = JSON.parse(xhr.responseText);
                console.log( "Login deleteSessionResponse: " + xhr.responseText );
                if (xhr.status == 200) {
                    mainRect.password = "";
                    mainRect.auth_token = "";
                    messageText.text = postSessionResponse.info;
                    emailTextInput.text = "";
                    passwordTextInput.text = "";
                    emailTextInputRectangle.color = "#00000000";
                    passwordTextInputRectangle.color = "#00000000";
                    rootLogin.loginSwitch = "login";
                    loginButton.text = qsTr("Login");
                    rootLogin.loginok(); // emit signal to refresh the list
                } else {
                    messageText.text = qsTr("error Logout");
                }
            }
        }
        xhr.send(JSON.stringify({user:{email:emailTextInput.text, password:passwordTextInput.text}}));
        console.log("delete user JSON.stringify", JSON.stringify({user:{email:emailTextInput.text, password:passwordTextInput.text}}));
    }
}
