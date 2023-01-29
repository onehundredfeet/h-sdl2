// Derived from code in the hashlink repository
// This is only intended as solution for a drop-in replacement when using SDL2 with Heaps but not hashlink

package sdl;

import sdl.Window;

#if heaps_metal
class WindowMetal extends Window {
    public function new( title : String, width : Int, height : Int, x : Int = Window.SDL_WINDOWPOS_CENTERED, y : Int = Window.SDL_WINDOWPOS_CENTERED, sdlFlags : Int = Window.SDL_WINDOW_SHOWN | Window.SDL_WINDOW_RESIZABLE) {
        while( true ) {
			win = Window.winCreateEx(x, y, width, height, sdlFlags | Window.SDL_WINDOW_METAL );
			if( win == null ) throw "Failed to create window";
			break;
		}
        super(title);
    }
}

#end