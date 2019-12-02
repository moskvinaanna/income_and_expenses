import QtQuick 2.0
import Sailfish.Silica 1.0
SilicaListView {
    delegate: ListItem {
        id: delegate
        Label {
            id: label
        x: Theme.paddingLarge
        text: "Элемент #" + index
        anchors.verticalCenter: parent.verticalCenter
        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
    }
    menu: ContextMenu {
        MenuLabel {
            text: "Контекстное меню"
        }
        MenuItem {
            text: "Выделить жирным"
            onClicked: label.font.bold = !label.font.bold
        }
        MenuItem {
            text: "Выделить курсивом"
            onClicked: label.font.italic = !label.font.italic
        }
    }
}
}
