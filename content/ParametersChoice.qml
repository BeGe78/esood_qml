/*
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
*/ 

import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Private 1.0
import "."

Rectangle {
    id: root
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
    
    PinchArea {
        id: pinchArea
        pinch.target: root
        anchors.fill: parent
        property real m_x1: 0
        property real m_y1: 0
        property real m_y2: 5
        property real m_x2: root.width / 2
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
            root.x = root.x + (pinchArea.m_x1-pinchArea.m_x2)*(1-pinchArea.m_zoom1)
            root.y = root.y + (pinchArea.m_y1-pinchArea.m_y2)*(1-pinchArea.m_zoom1)
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

                pinchArea.m_x2 = root.width / 2
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
                root.x = root.x + (pinchArea.m_x1-pinchArea.m_x2)*(1-pinchArea.m_zoom1)
                root.y = root.y + (pinchArea.m_y1-pinchArea.m_y2)*(1-pinchArea.m_zoom1)
            }
            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Click in child")
            }
        }
    }
        
    ListModel {
        id: indicatorModel
    }
    ListModel {
        id: countryModel
    }

    Row {
        id: yearRow
        anchors.top: parent.top
        width: (yearBeginText.width + yearBeginTextInputRectangle.width + 10) * 2
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
    }
    Row {
        id: buttonRow
        anchors.top: yearRow.bottom
        width: countriesButton.width + indicatorsButton.width + 50
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
                console.log("GA sendEvent");
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
                console.log("GA sendHit");
                gAnalytics.sendHit("myView");
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
        }
    }

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
