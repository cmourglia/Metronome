#include "timer.h"

#include <iostream>
#include <thread>
#include <chrono>
#include <mutex>

static std::mutex mutex;

int getNbSubdivs(int subdivType) {
    switch (subdivType) {
        case Subdiv::Quarter:
            return 1;
        case Subdiv::Eighth:
            return 2;
        case Subdiv::Triplet:
            return 3;
        case Subdiv::Shuffle:
            return 3;
        case Subdiv::Sixteenth:
            return 4;
    }

    return 0;
}

using Clock = std::chrono::high_resolution_clock;
using TimePoint = Clock::time_point;

void timerLoop(Timer* timer) {
    using namespace std::chrono_literals;

    // Make sure we don't run two timers at the same time
    mutex.lock();
    const int nbSubdivs = getNbSubdivs(timer->subdiv());
    const double s = 1.0 / (((double)timer->bpm() / 60.0) * nbSubdivs);

    std::cout << timer->bpm() << " " << timer->subdiv() << " (" << nbSubdivs << ") " << s << std::endl;

    TimePoint t0 = Clock::now();

    int currentSubdiv = 0;
    int tick = 0;

    while (timer->running()) {
        TimePoint t1 = Clock::now();

        const std::chrono::duration<double> dt = t1 - t0;
        if (dt.count() >= s) {
            if (timer->subdiv() != Subdiv::Shuffle || currentSubdiv != 1) {
                timer->playHihat();
            }

            if (currentSubdiv == 0) {
                if (tick % 2 == 0) {
                    timer->playKick();
                } else {
                    timer->playSnare();
                }

                tick = (tick + 1) % 4;
            }

            currentSubdiv = (currentSubdiv + 1) % nbSubdivs;

            t0 = t1;
        }

        std::this_thread::sleep_for(50us);
    }

    mutex.unlock();
}

Timer::Timer(QObject* parent)
    : QObject(parent)
    , m_bpm(60)
    , m_subdiv(0)
    , m_running(false)
{
    m_hihatBuffer.loadFromFile("res/hihat.wav");
	m_hihat.setBuffer(m_hihatBuffer);

    m_snareBuffer.loadFromFile("res/snare.wav");
	m_snare.setBuffer(m_snareBuffer);

    m_kickBuffer.loadFromFile("res/kick.wav");
	m_kick.setBuffer(m_kickBuffer);
}

Timer::~Timer() {
    stop();
    mutex.lock();
    mutex.unlock();
}

void Timer::start()
{
    mutex.lock();
    mutex.unlock();

    m_running = true;

    connect(this, &Timer::bpmChanged, this, &Timer::restart);
    connect(this, &Timer::subdivChanged, this, &Timer::restart);

    std::thread t(timerLoop, this);
    t.detach();
}

void Timer::stop()
{
    m_running = false;

    disconnect(this, &Timer::bpmChanged, this, &Timer::restart);
    disconnect(this, &Timer::subdivChanged, this, &Timer::restart);
}
