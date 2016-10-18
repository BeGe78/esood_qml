import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Private 1.0
import QtQuick.Dialogs 1.2
import "."
/*!
\qmltype ParametersChoice

\brief ESoOd parameters choice screen composed of years, indicators and countries.
\section2 Licensing
\legalese
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
\endlegalese 
*/
Rectangle {
    id: root
    /*!
        \qmlproperty string email
        email for registered and connected user
    */
    property string email: "" 
    width: 320
    height: 410
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    color: "white"
    transform: Scale {
        id: scaler
        origin.x: root.width / 2
        origin.y: 5
        xScale: pinchArea.m_zoom2
        yScale: pinchArea.m_zoom2
    }
    
    EsoodPinchArea { id: pinchArea }
        
    ListModel {
        id: indicatorModel
    }
    ListModel {
        id: countryModel
    }

    Row {
        id: yearRow
        anchors.top: parent.top
        width: (yearBeginText.width + yearBeginTextInputRectangle.width + 15) * 2
        height: yearBeginText.height + 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 9
        spacing: 5
        padding: 5

        Text {
            id: yearBeginText
            width: 90
            height: 30
            text: qsTr("Year Begin:")
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.family: "Verdana"
            font.pixelSize: 15
            MouseArea {
                anchors.fill: parent
                onPressed: yearHelp.open();
                onReleased: yearHelp.close();
            }
        }

        Rectangle {
            id: yearBeginTextInputRectangle
            width: 60
            height: 30
            color: "#00000000"
            radius: 2
            border.color: "#0d0000"
            TextInput {
                id: yearBeginTextInput
                width: 60
                height: 30
                cursorVisible: true
                verticalAlignment: TextInput.AlignVCenter
                text: qsTr("")
                validator: IntValidator{bottom: 1965; top: 2015;}
                font.family: "Verdana"
                font.pixelSize: 15
                onEditingFinished: mainRect.yearbegin = yearBeginTextInput.text
            }
        }
        Text {
            id: yearEndText
            width: 90
            height: 30
            text: qsTr("Year End: ")
            font.family: "Verdana"
            font.bold: true
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 15
            MouseArea {
                anchors.fill: parent
                onPressed: yearHelp.open();
                onReleased: yearHelp.close();
            }
        }
        Rectangle {
            id: yearEndTextInputRectangle
            width: 60
            height: 30
            color: "#00000000"
            radius: 2
            border.color: "#0d0000"
            TextInput {
                id: yearEndTextInput
                width: 60
                height: 30
                cursorVisible: true
                verticalAlignment: TextInput.AlignVCenter
                text: qsTr("")
                validator: IntValidator{bottom: 1965; top: 2015;}
                font.family: "Verdana"
                font.pixelSize: 14
                onEditingFinished: mainRect.yearend = yearEndTextInput.text
            }
        }
        Image {
            id: year_question_mark
            width: 30
            height: 30
            anchors.leftMargin: 20
            fillMode: Image.PreserveAspectFit
            source: "./images/question_mark.png"
            MouseArea {
                anchors.fill: parent
                //onClicked: yearHelp.open();
                onPressed: yearHelp.open();
                onReleased: yearHelp.close();
            }
        }
        Dialog {
            id: yearHelp
            contentItem: Rectangle {
                color: "white"
                implicitWidth: 400
                implicitHeight: 100
                TextTemplate {
                    label: qsTr("yearhelp")
                }
            }
        }
    }
    Row {
        id: buttonRow
        anchors.top: yearRow.bottom
        width: countriesButton.width + indicatorsButton.width + 40
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 9
        spacing: 40
        padding: 5
        Button {
            id: countriesButton
            radius: 3
            text: qsTr("Countries")
            buttonEnabled: true
            color: "#286090"
            onClicked: {
                indicator2Combo.height = 0;
                indicator2Combo.visible = false;
                indicatorsButton.color = "#337ABF";
                country2Combo.height = 35;
                country2Combo.visible = true;
                country1Combo.anchors.topMargin = 15
                countriesButton.color = "#286090";
                mainRect.formswitch = "country";
                //gAnalytics.sendEvent("Category", "Action", "Label", 1);
            }
        }
        Button {
            id: indicatorsButton
            radius: 3
            text: qsTr("Indicators")
            color: "#337ABF"
            onClicked: {
                indicator2Combo.height = 35;
                indicator2Combo.visible = true;
                indicatorsButton.color = "#286090";
                country2Combo.height = 0;
                country2Combo.visible = false;
                country1Combo.anchors.topMargin = 65
                countriesButton.color = "#337ABF";
                mainRect.formswitch = "indicator";
                gAnalytics.sendHit("myView");
            }
        }
        Image {
            id: button_question_mark
            width: 30
            height: 30
            anchors.leftMargin: 20
            fillMode: Image.PreserveAspectFit
            source: "./images/question_mark.png"
            MouseArea {
                anchors.fill: parent
                //onClicked: buttonHelp.open();
                onPressed: buttonHelp.open();
                onReleased: buttonHelp.close();
            }
        }
        Dialog {
            id: buttonHelp
            contentItem: Rectangle {
                color: "white"
                implicitWidth: 400
                implicitHeight: 100
                TextTemplate {
                    label: qsTr("buttonhelp")
                }
            }
        }
    }

    ComboBox {
        id: indicator1Combo
        width: 350
        height: 35
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: buttonRow.bottom
        anchors.topMargin: 15
        editable: false
        currentIndex: 1
        model: indicatorModel
        textRole: "name"
        style: ComboBoxStyle {
            background: Rectangle {
                color: "#fff"
                smooth: true
                radius: 5
                border.width: 1
                Image {
                    source: "images/down-arrow.png"
                    width: 10
                    height: 10
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 5
                    anchors.rightMargin: 5
                }
            }
            label: Label {
                verticalAlignment: Text.AlignVCenter
                width: 200
                anchors.left: parent.left
                renderType: Text.NativeRendering
                text: control.currentText
                elide: Text.ElideRight
                font: Qt.font({ pixelSize: 14 })
            }
        }
        onCurrentIndexChanged: {
            mainRect.currentIndicator1 = model.get(currentIndex).id1;
            mainRect.currentIndicator1Name = model.get(currentIndex).name;
        }
    }
    ComboBox {
        id: indicator2Combo
        width: 350
        height: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: indicator1Combo.bottom
        anchors.topMargin: 15
        editable: false
        visible: false
        currentIndex: 0
        model: indicatorModel
        textRole: "name"
        style: ComboBoxStyle {
            background: Rectangle {
                color: "#fff"
                smooth: true
                radius: 5
                border.width: 1
                Image {
                    source: "images/down-arrow.png"
                    width: 10
                    height: 10
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 5
                    anchors.rightMargin: 5
                }
            }
            label: Label {
                verticalAlignment: Text.AlignVCenter
                width: 200
                anchors.left: parent.left
                renderType: Text.NativeRendering
                text: control.currentText
                elide: Text.ElideRight
                font: Qt.font({ pixelSize: 14 })
            }
        }
        onCurrentIndexChanged: {
            mainRect.currentIndicator2 = model.get(currentIndex).id1;
            mainRect.currentIndicator2Name = model.get(currentIndex).name;
        }
    }
    ComboBox {
        id: country1Combo
        width: 350
        height: 35
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: indicator1Combo.bottom
        anchors.topMargin: 15
        editable: false
        currentIndex: 0
        model: countryModel
        textRole: "name"
        style: ComboBoxStyle {
            background: Rectangle {
                color: "#fff"
                smooth: true
                radius: 5
                border.width: 1
                Image {
                    source: "images/down-arrow.png"
                    width: 10
                    height: 10
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 5
                    anchors.rightMargin: 5
                }
            }
            label: Label {
                verticalAlignment: Text.AlignVCenter
                width: 200
                anchors.left: parent.left
                renderType: Text.NativeRendering
                text: control.currentText
                elide: Text.ElideRight
                font: Qt.font({ pixelSize: 14 })
            }
        }
        onCurrentIndexChanged: {
            mainRect.currentCountry1 = model.get(currentIndex).name;
        }
    }
    ComboBox {
        id: country2Combo
        width: 350
        height: 35
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: indicator1Combo.bottom
        anchors.topMargin: 65
        editable: false
        visible: true
        currentIndex: 1
        model: countryModel
        textRole: "name"
        style: ComboBoxStyle {
            background: Rectangle {
                color: "#fff"
                smooth: true
                radius: 5
                border.width: 1
                Image {
                    source: "images/down-arrow.png"
                    width: 10
                    height: 10
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 5
                    anchors.rightMargin: 5
                }
            }
            label: Label {
                verticalAlignment: Text.AlignVCenter
                width: 200
                anchors.left: parent.left
                renderType: Text.NativeRendering
                text: control.currentText
                elide: Text.ElideRight
                font: Qt.font({ pixelSize: 14 })
            }
        }
        onCurrentIndexChanged: {
            mainRect.currentCountry2 = model.get(currentIndex).name;
        }
    }

    Button {
        id: update
        x: 10
        radius: 3
        text: qsTr("Update")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: buttonRow.bottom
        anchors.topMargin: 170
        onClicked: {
            yearBeginTextInput.focus = false;
            yearEndTextInput.focus = false;
            var event = mainRect.email;
            event += ":";
            event += mainRect.yearbegin;
            event += ":";
            event += mainRect.yearend;
            event += ":";
            event += mainRect.currentIndicator1;
            event += ":";
            event += mainRect.currentIndicator2;
            event += ":";
            event += mainRect.currentCountry1;
            event += ":";
            event += mainRect.currentCountry2;
            gAnalytics.sendEvent("A-Selectors", mainRect.formswitch, event, 1);
            selectorsChartView.drawChart();
            mainRect.currentIndex = 2;
        }
    }
    /*!
        \qmlmethod getCountries()
        Retrieves the countries from the Worldbank database
    */
    function getCountries() {
        var req = "https://bege.hd.free.fr/api/v1/countries.json";
        var params = "?email=";
        params += mainRect.email;
        params += "&auth_token=";
        params += encodeURIComponent(mainRect.auth_token);
        params += '&language=';
        params += mainRect.language;
        
        var xhr = new XMLHttpRequest;
        xhr.open("GET", req + params , true);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var myArr = JSON.parse(xhr.responseText);
                mainRect.currentCountry1 = myArr[0].name;
                mainRect.currentCountry2 = myArr[1].name;
                countryModel.clear();
                if (myArr.length > 0 && xhr.status == 200) {
                    for(var i = 0; i < myArr.length; i++) {
                        countryModel.append({"id1":myArr[i].id1, "name":myArr[i].name});
                        if (myArr[i].id1 === "FRA") {
                            country1Combo.currentIndex = i;
                        }
                        if (myArr[i].id1 === "DEU") {
                            country2Combo.currentIndex = i;
                        }
                    }
                } else {
                    countryModel.append("error CountriesIndex")
                }
            }
        }
        xhr.send(null);
    }
    /*!
        \qmlmethod getIndicators()
        Retrieves the indicators from the Worldbank database
    */
    function getIndicators() {
        var req = "https://bege.hd.free.fr/api/v1/indicators.json";
        var params = "?email=";
        params += mainRect.email;
        params += "&auth_token=";
        params += encodeURIComponent(mainRect.auth_token);
        params += '&language=';
        params += mainRect.language;
        var xhr = new XMLHttpRequest;
        xhr.open("GET", req + params, true);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var myArr = JSON.parse(xhr.responseText);
                mainRect.currentIndicator1 = myArr[0].id1;
                mainRect.currentIndicator1Name = myArr[0].name;
                mainRect.currentIndicator2 = myArr[1].id1;
                mainRect.currentIndicator2Name = myArr[1].name;
                indicatorModel.clear();
                if (myArr.length > 0 && xhr.status == 200) {
                    for(var i = 0; i < myArr.length; i++) {
                        indicatorModel.append({"id1":myArr[i].id1, "name":myArr[i].name});
                        if (myArr[i].id1 === "NY.GDP.PCAP.CN") {
                            indicator1Combo.currentIndex = i;
                        }
                        if (myArr[i].id1 === "NY.GDP.MKTP.CN") {
                            indicator2Combo.currentIndex = i;
                        }
                    }
                } else {
                    indicatorModel.append("error IndicatorsIndex")
                }
            }
        }
        xhr.send(null);
    }

    Component.onCompleted: {
        //mainRect.currentIndex = 1;
        getIndicators();
        getCountries();
    }
}
