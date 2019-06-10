#pragma once

#include <QObject>

#include <SFML/Audio.hpp>

#include <atomic>

class Subdiv : public QObject {
    Q_OBJECT

public:
    enum EnumSubdiv {
        Quarter = 0,
        Eighth,
        Triplet,
        Shuffle,
        Sixteenth,
    };
    Q_ENUMS(EnumSubdiv);

public:
    Subdiv() : QObject() {}
};

class Timer : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int bpm READ bpm WRITE setBpm NOTIFY bpmChanged)
    Q_PROPERTY(int subdiv READ subdiv WRITE setSubdiv NOTIFY subdivChanged)
    Q_PROPERTY(bool running READ running)

public:
    explicit Timer(QObject* parent = nullptr);
    virtual ~Timer();

    int bpm() const { return m_bpm; }
    void setBpm(int bpm) {
        if (bpm != m_bpm) {
            m_bpm = bpm;
            emit bpmChanged(bpm);
        }
    }

    int subdiv() const { return m_subdiv; }
    void setSubdiv(int subdiv) {
        if (subdiv != m_subdiv) {
            m_subdiv = subdiv;
            emit subdivChanged(subdiv);
        }
    }

    bool running() const {
        return m_running;
    }

public slots:
    void start();
    void stop();
    void restart() { stop(); start(); }

    void playHihat() { m_hihat.play(); }
    void playSnare() { m_snare.play(); }
    void playKick() { m_kick.play(); }

signals:
    void bpmChanged(int bpm);
    void subdivChanged(int subdiv);

private:
    int m_bpm;
    int m_subdiv;

    std::atomic_bool m_running;

    sf::Sound m_hihat;
    sf::SoundBuffer m_hihatBuffer;

    sf::Sound m_snare;
    sf::SoundBuffer m_snareBuffer;

    sf::Sound m_kick;
    sf::SoundBuffer m_kickBuffer;
};
