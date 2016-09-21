/*
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
 
The application GUI is composed of a fix banner and 4 flickable pages implemented with a ListView:
    - Login
    - Parameters selection
    - Chart 
    - Statistics
Each page supports zoom (mouse wheel or pinch).
The last 2 pages support horizontal and vertical drag.
*/

import QtQuick 2.7
import QtQml.Models 2.1
import "./content"

Rectangle {
    id: mainRect
    width: 1000
    height: 700

    property alias currentIndex: root.currentIndex
    property string currentCountry1: ""
    property string currentCountry2: ""
    property string currentIndicator1: ""
    property string currentIndicator1Name: ""
    property string currentIndicator2: ""
    property string currentIndicator2Name: ""
    property string formswitch: "country"
    property string yearbegin: ""
    property string yearend: ""
    property string email: ""
    property string password: ""
    property string auth_token: ""
    property string language: Qt.locale("").name
    //property string language: Qt.locale("en_EN").name // to test english
    property double mean1: 0.0
    property double mean2: 0.0
    property double coeflm1: 0.0
    property double coeflm2: 0.0
    property double coeflm3_1: 0.0
    property double coeflm3_2: 0.0
    property string meanrate1: ""
    property string meanrate2: ""
    property string cor: ""
    

    Rectangle {
        id: banner
        height: 60
        border.width: 1
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ffffff"
            }

            GradientStop {
                position: 1
                color: "#F8DE86"
            }
        }
        anchors.top: parent.top        
        width: parent.width
        Item {
            id: esood
            width: esoodText.width
            height: esoodText.height
            anchors.horizontalCenter: banner.horizontalCenter
            anchors.verticalCenter: banner.verticalCenter

            Text {
                id: esoodText
                anchors.verticalCenter: esood.verticalCenter
                color: "#000000"
                font.family: "Verdana"
                font.pointSize: 32
                text: "ESoOD"
                font.bold: true
            }
        }
    }

    ListView {
        id: root
        width: parent.width
        layoutDirection: Qt.LeftToRight
        contentWidth: 1000
        anchors.top: banner.bottom
        anchors.bottom: parent.bottom
        spacing: 0
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 250
        focus: false
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        pressDelay: 1000 //events delivered after 1 sec to be able to drag

        model: ObjectModel {
            Login {
                id: login
                width: root.width
                height: root.height
                onLoginok: { //refresh lists if new login
                    parametersChoice.getCountries();
                    parametersChoice.getIndicators();
                }
            }

            ParametersChoice {
                id: parametersChoice
                width: root.width
                height: root.height
                email: mainRect.email
            }
            
            SelectorsChartView {
                id: selectorsChartView
                width: root.width
                height: root.height
            }
            SelectorsStatView {
                id: selectorsStatView
                width: root.width
                height: root.height
            }
        }
    }
}
