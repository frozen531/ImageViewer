import QtQuick 2.9
import QtQuick.Window 2.2 // Window
import QtQuick.Controls 1.2 // Button
import QtQuick.Controls.Styles 1.2 // ButtonStyle，只有当import QtQuick.Controls 1.x时Button才有style属性
import QtQuick.Dialogs 1.2 // FileDialog

Window {
    visible: true
    width: 640
    height: 480
    minimumWidth: 320
    minimumHeight: 240
    title: qsTr("ImageViewer")

    Image {
        id: imageViewer
        asynchronous: true // 大图片开启异步加载模式(只有加载本地图片时这样设置起作用)，对于网络图片，默认异步加载图片
        cache: false // 图片不缓存
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit // 图片采用等比例缩放
        onStatusChanged: { // 当status属性变化时发射statusChanged()信号
            if(imageViewer.status === Image.Loading){ // 图片加载时，转圈，文本不显示
                busy.running = true
                stateLable.visible = false
            }
            else if(imageViewer.status === Image.Ready){ // 图片加载成功
                busy.running = false
            }
            else if(imageViewer.status === Image.Error){ // 图片加载失败
                busy.running = false
                stateLable.visible = true
                stateLable.text = "ERROR"
            }
        }
    }

    BusyIndicator{ // BusyIndicator只有running和style两个自己的属性
        id: busy
        running: false // true显示
        anchors.centerIn: parent
        z: 2
    }

    Text { // 图片加载错误时文本显示
        id: stateLable
        visible: false // 不可见
        anchors.centerIn: parent
        z: 3
    }

    Button{
        id: openFile
        text: "Open"
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        style: btstyle
        onClicked: {
            fileDialog.open()
        }
        z: 4
    }

    Component{ // Button按钮的风格定制
        id: btstyle
        ButtonStyle{
            background: Rectangle{ // background的类型为Component
                implicitWidth: 70
                implicitHeight: 25
                color: "#dddddddd"
                border.width: control.pressed ? 2 : 1 // 按钮按下，边界宽度加粗
                border.color: (control.hovered || control.pressed) // 按钮按下或悬停，颜色变绿
                                ? "green" : "#88888888"
            }
        }
    }

    Text {
        id: imagePath
        anchors.left: openFile.right
        anchors.leftMargin: 8
        anchors.verticalCenter: openFile.verticalCenter
        font.pixelSize: 18
    }

    FileDialog{
        id: fileDialog
        title: "Please choose a file"
        nameFilters: ["Image Files (*.jpg *.png *.gif)"] // 名字过滤列表
        onAccepted: {
            imageViewer.source = fileDialog.fileUrl
            var imageFile = new String(fileDialog.fileUrl) // 变量，转成String类型
            imagePath.text = imageFile.slice(8)
        }
    }
}
