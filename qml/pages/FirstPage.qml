import QtQuick 2.0
import Sailfish.Silica 1.0
import "db.js" as JS
import QtQuick.LocalStorage 2.0

Page {
    id: page
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All
    Component.onCompleted: {
        JS.dbInit()
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Добавить новую операцию")
                onClicked: function(){
                    listmodel.append({id: JS.dbInsert("расход", "еда", 100, "вкусно"),
                                         category: "еда"})
                }
            }
            MenuItem {
                text: qsTr("Статистика")
                onClicked:pageStack.push(Qt.resolvedUrl("SecondPage.qml"), {id: 13})
            }
        }

        SilicaListView {
            id: listView
            model: ListModel{
                id: listmodel
                Component.onCompleted: JS.dbReadAll()
            }
            anchors.fill: parent
            header: PageHeader {
                title: qsTr("Доходы и расходы")
            }

            delegate: ListItem {
                id: delegate
                Label {
                    id: label
                x: Theme.paddingLarge
                text: category
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
                Label {
                    id: label2
                    text: sum
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
            menu: ContextMenu {
                MenuLabel {
                    text: "Контекстное меню"
                }
                MenuItem {
                    text: "Удалить операцию"
                    onClicked: {
                        JS.dbDeleteRow(listmodel.get(index).id)
                        listmodel.remove(index)
                    }
                }
                MenuItem {
                    text: "Редактировать операцию"
                    onClicked: label.font.italic = !label.font.italic
                }
            }
        }
            VerticalScrollDecorator {}
        }
    }
}
