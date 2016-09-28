import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQml.Models 2.1
import "./content"

/*!
\qmltype esood
\brief entry of the ESoOD project qml interface 
The application GUI is composed of a fix banner with directional arrows and 4 flickable pages implemented with a ListView:
    \list
        \li Login
        \li Parameters selection
        \li Chart 
        \li Statistics
    \endlist
Each page supports zoom (mouse wheel or pinch).
The last 2 pages support horizontal and vertical drag.
\section2 Licensing    
\legalese
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
\endlegalese
*/
Rectangle {
    id: mainRect
    width: 1000
    height: 700
    /*! page index used to manage the directional arrows */
    property alias currentIndex: root.currentIndex
    /*! selected country1 name */
    property string currentCountry1: ""
    /*! selected country2 name */
    property string currentCountry2: ""
    /*! selected indicator1 id */
    property string currentIndicator1: ""
    /*! selected indicator1 name */
    property string currentIndicator1Name: ""
    /*! selected indicator2 id */
    property string currentIndicator2: ""
    /*! selected indicator2 name */
    property string currentIndicator2Name: ""
    /*! used to toggle between country and indicator form */
    property string formswitch: "country"
    /*! selected yearbegin string between 1965 and 2015 */
    property string yearbegin: ""
    /*! selected yearend string between 1965 and 2015 */
    property string yearend: ""
    /*! email of the logged user */
    property string email: ""
    /*! encrypted password of the logged user */
    property string password: ""
    /*! authentification token returned after successful login */
    property string auth_token: ""
    /*! language of the android device = Qt.locale("").name */
    property string language: Qt.locale("").name
    //property string language: Qt.locale("en_EN").name // to test english
    
    /*! mean value of serie1 */
    property double mean1: 0.0
    /*! mean value of serie2 */
    property double mean2: 0.0
    /*! slope of serie1 */
    property double coeflm1: 0.0
    /*! slope of serie2 */
    property double coeflm2: 0.0
    /*! determination of the linear regression for serie1 */
    property double coeflm3_1: 0.0
    /*! determination of the linear regression for serie2 */
    property double coeflm3_2: 0.0
    /*! mean variation of serie1 */
    property string meanrate1: ""
    /*! mean variation of serie2 */
    property string meanrate2: ""
    /*! correlation between the two series */
    property string cor: ""

    Rectangle {
        /* the banner is composed of a title and left-right arrows, visible or not depending upon the page index */
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
        Image {
            id: left_arrow
            source: "./content/images/icon-left-arrow.png"
            anchors.left: banner.left
            anchors.leftMargin: 20
            anchors.verticalCenter: banner.verticalCenter
            visible: root.currentIndex > 0 ? true : false
            MouseArea {
                anchors.fill: parent
                onClicked: root.currentIndex = root.currentIndex - 1;
            }
        }
        Image {
            id: right_arrow
            source: "./content/images/icon-right-arrow.png"
            anchors.right: banner.right
            anchors.leftMargin: 20
            anchors.verticalCenter: banner.verticalCenter
            visible: root.currentIndex < 3 ? true : false
            MouseArea {
                anchors.fill: parent
                onClicked: root.currentIndex = root.currentIndex + 1;
            }
        }
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
    /* the ListView handles the snap and flick Mode of the 4 pages */
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
        
        /* the ObjectModel is composed of the 4 models */
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
