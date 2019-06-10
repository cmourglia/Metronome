import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import QtMultimedia 5.12

import metronome 4.2

ApplicationWindow {
    id: root
    width: 400
    height: 600
    visible: true

    Material.theme: Material.Dark
    Material.accent: Material.Teal

    property int bpm : 60
    property int subdiv : Subdiv.Quarter
    property int tick : 0
    property int tickCount: 4
    property int timeSubdivision: 0;
    property int currentSubdiv : 0;

    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Space) {
                toggleTimer();
                event.accepted = true;
            }
        }
    }

    function toggleTimer() {
        if (timer.running) {
            timer.stop();
            startButton.text = "Start";
        } else {
            timer.start();
            startButton.text = "Stop";
        }
    }

    ZTimer {
        id: timer
        bpm: root.bpm
    }

//    Timer {
//        id: timer
//        interval: 1000
//        repeat: true
//        triggeredOnStart: true

//        property int precount : 0

//        onTriggered: {
//            // console.log(root.count, root.noteLength, root.count % 2, (root.count + root.noteLength) % 4)
//            console.log(timeSubdivision, currentSubdiv);
//            if (timeSubdivision != subdiv_SHUFFLE || currentSubdiv != 1) {
//                hihat.play()
//            }

//            if (currentSubdiv == 0) {
//                if (root.tick % 2 == 0) {
//                    bass.play()
//                } else if (root.tick %  2 == 1) {
//                    clap.play()
//                }

//                root.tick = (root.tick + 1) % tickCount;
//            }

//            currentSubdiv = (currentSubdiv + 1) % getNbSubdivs();
//        }
//    }

//    function resetTimer() {
//        const timerMul = getNbSubdivs();
//        timer.interval = 1000 / ((root.bpm / 60) * timerMul);
//        root.currentSubdiv = 0;
//        root.tick = 0;
////        root.count = 0;
//        if (timer.running) timer.restart();
//    }

    SoundEffect {
        id: hihat
        source: "hh_sample.wav"
    }

    SoundEffect {
        id: clap
        source: "clap_sample.wav"
    }

    SoundEffect {
        id: bass
        source: "bass_sample.wav"
    }

    Column {
        anchors.fill: parent

        Button {
            clip: true

            id: startButton
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Start"
            onClicked: {
                toggleTimer();
            }
        }

        Row {
            clip: true

            id: timeSelector
            anchors.left: parent.left
            anchors.right: parent.right

            Button {
                id: decrement10
                width: 50
                text: "-10"
                onClicked: bpm.text = parseInt(bpm.text) - 10
            }

            Button {
                id: decrement1
                width: 50
                text: "-"
                onClicked: bpm.text = parseInt(bpm.text) - 1
            }

            TextField {
                id: bpm
                text: "60"
                font.pointSize: 24
                horizontalAlignment: Text.AlignHCenter
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                onTextChanged: {
                    var bpmValue = parseInt(bpm.text);
                    if (bpmValue && bpmValue !== Number.Nan) {
                        root.bpm = bpmValue;
                        timer.bpm = bpmValue;
//                        resetTimer();
                    } else {
                        text = root.bpm;
                    }
                }
            }

            Button {
                id: increment1
                width: 50
                text: "+"
                onClicked: {bpm.text = parseInt(bpm.text) + 1;
                timer.playBass();
                }
            }

            Button {
                id: increment10
                width: 50
                text: "+10"
                onClicked: bpm.text = parseInt(bpm.text) + 10
            }
        }

        ButtonGroup {
            buttons: noteLength.children
        }

        Row {
            id: noteLength
            anchors.left: parent.left
            anchors.right: parent.right

            TimeRadioButton {
                checked: true
                noteValue: Subdiv.Quarter
                timer: timer
            }

            TimeRadioButton {
                noteValue: Subdiv.Eighth
                timer: timer
            }

            TimeRadioButton {
                noteValue: Subdiv.Triplet
                timer: timer
            }

            TimeRadioButton {
                noteValue: Subdiv.Shuffle
                timer: timer
            }

            TimeRadioButton {
                noteValue: Subdiv.Sixteenth
                timer: timer
//                text: "Sixteenth"
//                onCheckedChanged: {
//                    if (checked) {
//                        root.timeSubdivision = subdiv_SIXTEENTH;
//                        timer.subdiv = Subdiv.Sixteenth;
////                        resetTimer();
//                    }
//                }
            }
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            Text {
                width: parent.width / 2
                text: "Measure pre-count"
            }

            SpinBox {
                id: measureCount
                width: parent.width / 2
                value: 0
                from: 0
                to: 10
                editable: true
            }
        }
    }
}

