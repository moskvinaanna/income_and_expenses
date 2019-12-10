import QtQuick 2.0
import Sailfish.Silica 1.0
import "db.js" as JS
import QtQuick.LocalStorage 2.0

Page {
    id: page
    property var id

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: ListModel{
            id: listmodel
            Component.onCompleted: JS.dbGetOperations()
        }
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Статистика")
        }

        delegate: ListItem {
            id: delegate
            Label {
                anchors.top:parent.top
                id: label
                x: Theme.paddingLarge
                text: results
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            //            Label {
            //                id: label2
            //                text: sum
            //                anchors.right: parent.right
            //                anchors.verticalCenter: parent.verticalCenter
            //                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            //            }


        }
        Button{
            anchors.horizontalCenter: parent.horizontalCenter
            y: 700
            text: "График"
            onClicked: function(){
                pageStack.push(Qt.resolvedUrl("Graphs.qml"))
            }
        }
    }
}
