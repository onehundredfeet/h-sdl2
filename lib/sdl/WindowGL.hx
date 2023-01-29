// Derived from code in the hashlink repository
// This is only intended as solution for a drop-in replacement when using SDL2 with Heaps but not hashlink

package sdl;

#if !hlsdl_no_gl
import sdl.Window;

private typedef GLContext = hl.Abstract<"sdl_gl">;

@:hlNative("sdl")
class WindowGL extends sdl.Window {
    var glctx : GLContext;

    public static inline var DOUBLE_BUFFER            = 1 << 0;
	public static inline var GL_CORE_PROFILE          = 1 << 1;
	public static inline var GL_COMPATIBILITY_PROFILE = 1 << 2;
	public static inline var GL_ES                    = 1 << 3;

    public function new( title : String, width : Int, height : Int, x : Int = Window.SDL_WINDOWPOS_CENTERED, y : Int = Window.SDL_WINDOWPOS_CENTERED, sdlFlags : Int = Window.SDL_WINDOW_SHOWN | Window.SDL_WINDOW_RESIZABLE) {
        while( true ) {
			win = Window.winCreateEx(x, y, width, height, sdlFlags | Window.SDL_WINDOW_OPENGL );
			if( win == null ) throw "Failed to create window";
			glctx = winGetGLContext(win);
			if( glctx == null || !GL.init() || !testGL() ) {
				destroy();
				if( onGlContextRetry() ) continue;
				onGlContextError();
			}
			break;
		}
        super(title);
    }

    function testGL() {
		try {

			var reg = ~/[0-9]+\.[0-9]+/;
			var v : String = GL.getParameter(GL.SHADING_LANGUAGE_VERSION);

			var glv : String = GL.getParameter(GL.VERSION);
			var isOpenGLES : Bool = ((glv!=null) && (glv.indexOf("ES") >= 0));

			var shaderVersion = 120;
			if (isOpenGLES) {
				if( reg.match(v) )
					shaderVersion = Std.int(Math.min( 100, Math.round( Std.parseFloat(reg.matched(0)) * 100 ) ));
			}
			else {
				shaderVersion = 130;
				if( reg.match(v) ) {
					var minVer = 150;
					shaderVersion = Math.round( Std.parseFloat(reg.matched(0)) * 100 );
					if( shaderVersion < minVer ) shaderVersion = minVer;
				}
			}

			var vertex = GL.createShader(GL.VERTEX_SHADER);
			GL.shaderSource(vertex, ["#version " + shaderVersion, "void main() { gl_Position = vec4(1.0); }"].join("\n"));
			GL.compileShader(vertex);
			if( GL.getShaderParameter(vertex, GL.COMPILE_STATUS) != 1 ) throw "Failed to compile VS ("+GL.getShaderInfoLog(vertex)+")";

			var fragment = GL.createShader(GL.FRAGMENT_SHADER);
			if (isOpenGLES)
				GL.shaderSource(fragment, ["#version " + shaderVersion, "lowp vec4 color; void main() { color = vec4(1.0); }"].join("\n"));
			else
				GL.shaderSource(fragment, ["#version " + shaderVersion, "out vec4 color; void main() { color = vec4(1.0); }"].join("\n"));
			GL.compileShader(fragment);
			if( GL.getShaderParameter(fragment, GL.COMPILE_STATUS) != 1 ) throw "Failed to compile FS ("+GL.getShaderInfoLog(fragment)+")";

			var p = GL.createProgram();
			GL.attachShader(p, vertex);
			GL.attachShader(p, fragment);
			GL.linkProgram(p);

			if( GL.getProgramParameter(p, GL.LINK_STATUS) != 1 ) throw "Failed to link ("+GL.getProgramInfoLog(p)+")";

			GL.deleteShader(vertex);
			GL.deleteShader(fragment);

		} catch( e : Dynamic ) {

			return false;
		}
		return true;
	}

    	/**
		Set the current window you will render to (in case of multiple windows)
	**/
	public override function renderTo() {
		winGlRenderTo(win, glctx);
	}

    public override function destroy() {
		try winGlDestroy(win, glctx) catch( e : Dynamic ) {};
		win = null;
		glctx = null;
        super.destroy();
	}
    override function set_vsync(v) {
		setGlVsync(v);
		return vsync = v;
	}

    static function winGetGLContext( win : WinPtr ) : GLContext {
		return null;
	}
    static function winGlRenderTo( win : WinPtr, gl : GLContext ) {
	}

	static function winGlDestroy( win : WinPtr, gl : GLContext ) {
	}

    public static var requiredGLMajor(default,null) = 3;
	public static var requiredGLMinor(default,null) = 2;


    public static function setGLOptions( major : Int = 3, minor : Int = 2, depth : Int = 24, stencil : Int = 8, flags : Int = 1, samples : Int = 1 ) {
		requiredGLMajor = major;
		requiredGLMinor = minor;
		glOptions(major, minor, depth, stencil, flags, samples);
	}
    static function glOptions( major : Int, minor : Int, depth : Int, stencil : Int, flags : Int, samples : Int ) {}

    public static dynamic function onGlContextRetry() {
		return false;
	}

	public static dynamic function onGlContextError() {
		var devices = Sdl.getDevices();
		var device = devices[0];
		if( device == null ) device = "Unknown";
		var flags = new haxe.EnumFlags<hl.UI.DialogFlags>();
		flags.set(IsError);
		var msg = 'The application was unable to create an OpenGL context\nfor your $device video card.\nOpenGL $requiredGLMajor.$requiredGLMinor+ is required, please update your driver.';
        trace(msg);
		hl.UI.dialog("OpenGL Error", msg, flags);
		Sys.exit( -1);
	}

    public override function present() {
		if( vsync && @:privateAccess Sdl.isWin32 ) {
			// NVIDIA OpenGL windows driver does implement vsync as an infinite loop, causing high CPU usage
			// make sure to sleep a bit here based on how much time we spent since the last frame
			var spent = haxe.Timer.stamp() - lastFrame;
			if( spent < 0.005 ) Sys.sleep(0.005 - spent);
		}
		winGlSwapWindow(win);
		lastFrame = haxe.Timer.stamp();
	}



    public static function setGlVsync( b : Bool ) {
	}

    static function winGlSwapWindow( win : WinPtr ) {
	}

    /*
    static function winGlDestroy( win : WinPtr ) {
	}
    */
}
#end