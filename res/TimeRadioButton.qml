import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12

import metronome 4.2

RadioButton {
    property int noteValue
    property var timer

    Material.theme: Material.Dark
    readonly property string quarterChar: "q"
    readonly property string eighthChar: "n"
    readonly property string tripletChar: "T"
    readonly property string shuffleChar: "¼"
    readonly property string sixteenthChar: "y"

    implicitWidth: 80
    implicitHeight: 80

    text: {
        switch (noteValue) {
        case Subdiv.Quarter: return quarterChar;
        case Subdiv.Eighth: return eighthChar;
        case Subdiv.Triplet: return tripletChar;
        case Subdiv.Shuffle: return shuffleChar;
        case Subdiv.Sixteenth: return sixteenthChar;
        }

        return "";
    }

    FontLoader {
        id: musicFont
        source: "./MusiSync.ttf"
    }

    background: Item {
        anchors.fill: parent
        Rectangle {
            id: backgroundItem
            anchors.fill: parent
            radius: 5
            anchors.margins: 5
            color: checked ? "#888" : "#424242"
        }

        DropShadow {
            source: backgroundItem
            anchors.fill: source
            horizontalOffset: 3
            verticalOffset: 3
            radius: backgroundItem.radius
            antialiasing: true
            samples: 16
            smooth: true
        }
    }

    indicator: Image {
        anchors.fill: parent
        source: {
            switch (noteValue) {
                case Subdiv.Quarter: return "quarter.png";
                case Subdiv.Eighth: return "eigth.png";
                case Subdiv.Triplet: return "triplet.png";
                case Subdiv.Shuffle: return "shuffle.png";
                case Subdiv.Sixteenth: return "sixteenth.png";
            }
        }
    }


    contentItem: Item {}

    onCheckedChanged: {
        if (checked) {
            timer.subdiv = noteValue;
        }
    }
}
