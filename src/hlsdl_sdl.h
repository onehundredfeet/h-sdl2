#pragma once

class Sdl {
    static bool initOnce();
    static void quit();
    static void delay(int ms);
    static bool eventLoop();
};
