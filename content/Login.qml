import QtQuick 2.7
import QtQuick.Controls 1.2
import "."
/*!
\qmltype Login

\brief Login screen asking for the email and the password
 
Please note that the registration/subscription is handled only on the browser interface and not on the android interface.
\section2 Licensing
\legalese
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
\endlegalese
*/
Rectangle {
    id: rootLogin
    /*! switch between login and logout */
    property string loginSwitch: "login"
    /*! this signal handles the success of the login */
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
    
    EsoodPinchArea { id: pinchArea }

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
    /*!
        \qmlmethod postSession()
        AJAX post to create the session via ESoOD API.
        An authentification token is given.
    */
    function postSession() {
        var req = "https://bege.hd.free.fr/api/v1/sessions.json";
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
    /*!
        \qmlmethod deleteSession()
        AJAX delete to destroy the session via ESoOD API
    */
    function deleteSession() {
        var req = "https://bege.hd.free.fr/api/v1/sessions.json";
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
