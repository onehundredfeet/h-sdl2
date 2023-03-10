package sdl;

typedef WinPtr = hl.Abstract<"sdl_window">;
typedef DisplayHandle = Null<Int>;

@:enum abstract DisplayMode(Int) {
	var Windowed = 0;
	var Fullscreen = 1;
	var Borderless = 2;
}

typedef DisplaySetting = {
	width : Int,
	height : Int,
	framerate : Int
}

@:hlNative("sdl")
class Window {

	static var windows : Array<Window> = [];

	public static inline var SDL_WINDOWPOS_UNDEFINED = 0x1FFF0000;
	public static inline var SDL_WINDOWPOS_CENTERED  = 0x2FFF0000;

	public static inline var SDL_WINDOW_FULLSCREEN         = 0x00000001;
	public static inline var SDL_WINDOW_OPENGL             = 0x00000002;
	public static inline var SDL_WINDOW_SHOWN              = 0x00000004;
	public static inline var SDL_WINDOW_HIDDEN             = 0x00000008;
	public static inline var SDL_WINDOW_BORDERLESS         = 0x00000010;
	public static inline var SDL_WINDOW_RESIZABLE          = 0x00000020;
	public static inline var SDL_WINDOW_MINIMIZED          = 0x00000040;
	public static inline var SDL_WINDOW_MAXIMIZED          = 0x00000080;
	public static inline var SDL_WINDOW_INPUT_GRABBED      = 0x00000100;
	public static inline var SDL_WINDOW_INPUT_FOCUS        = 0x00000200;
	public static inline var SDL_WINDOW_MOUSE_FOCUS        = 0x00000400;
	public static inline var SDL_WINDOW_FULLSCREEN_DESKTOP = 0x00001001;
	public static inline var SDL_WINDOW_FOREIGN            = 0x00000800;
	public static inline var SDL_WINDOW_ALLOW_HIGHDPI      = 0x00002000;
	public static inline var SDL_WINDOW_MOUSE_CAPTURE      = 0x00004000;
	public static inline var SDL_WINDOW_ALWAYS_ON_TOP      = 0x00008000;
	public static inline var SDL_WINDOW_SKIP_TASKBAR       = 0x00010000;
	public static inline var SDL_WINDOW_UTILITY            = 0x00020000;
	public static inline var SDL_WINDOW_TOOLTIP            = 0x00040000;
	public static inline var SDL_WINDOW_POPUP_MENU         = 0x00080000;
	public static inline var SDL_WINDOW_VULKAN             = 0x10000000;
	public static inline var SDL_WINDOW_METAL              = 0x20000000;
	

	var win : WinPtr;
	var lastFrame : Float;
	public var title(default, set) : String;
	public var vsync(default, set) : Bool;
	public var width(get, never) : Int;
	public var height(get, never) : Int;
	public var minWidth(get, never) : Int;
	public var minHeight(get, never) : Int;
	public var maxWidth(get, never) : Int;
	public var maxHeight(get, never) : Int;
	public var x(get, never) : Int;
	public var y(get, never) : Int;
	public var displayMode(default, set) : DisplayMode;
	public var displaySetting : DisplaySetting;
	public var currentMonitor(get, default) : Int;
	public var visible(default, set) : Bool = true;
	public var opacity(get, set) : Float;
	public var grab(get, set) : Bool;

	function new( title : String ) {

		this.title = title;
		windows.push(this);
	}


	function set_title(name:String) {
		winSetTitle(win, @:privateAccess name.toUtf8());
		return title = name;
	}

	function set_displayMode(mode) {
		if( winSetFullscreen(win, mode) ) {
			displayMode = mode;
			if(mode == Fullscreen) {
				try @:privateAccess sdl.Window.winSetDisplayMode(win, displaySetting.width, displaySetting.height, displaySetting.framerate) catch(_) {}
			}
		}
		return displayMode;
	}

	function set_visible(b) {
		if( visible == b )
			return b;
		winResize(win, b ? 3 : 4);
		return visible = b;
	}

	public function resize( width : Int, height : Int ) {
		winSetSize(win, width, height);
	}

	public function setMinSize( width : Int, height : Int ) {
		winSetMinSize(win, width, height);
	}

	public function setMaxSize( width : Int, height : Int ) {
		winSetMaxSize(win, width, height);
	}

	public function setPosition( x : Int, y : Int ) {
		winSetPosition(win, x, y);
	}

	public function center() {
		setPosition(SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED);
	}

	public function warpMouse( x : Int, y : Int ) {
		warpMouseInWindow(win, x, y);
	}

	function get_width() {
		var w = 0;
		winGetSize(win, w, null);
		return w;
	}

	function get_height() {
		var h = 0;
		winGetSize(win, null, h);
		return h;
	}

	function get_minWidth() {
		var w = 0;
		winGetMinSize(win, w, null);
		return w;
	}

	function get_minHeight() {
		var h = 0;
		winGetMinSize(win, null, h);
		return h;
	}

	function get_maxWidth() {
		var w = 0;
		winGetMaxSize(win, w, null);
		return w;
	}

	function get_maxHeight() {
		var h = 0;
		winGetMaxSize(win, null, h);
		return h;
	}

	function get_x() {
		var x = 0;
		winGetPosition(win, x, null);
		return x;
	}

	function get_y() {
		var y = 0;
		winGetPosition(win, null, y);
		return y;
	}

	function get_currentMonitor() {
		return winDisplayHandle(win);
	}

	function set_vsync(v) {
		return v;
	}

	function get_opacity() {
		return winGetOpacity(win);
	}

	function set_opacity(v) {
		winSetOpacity(win, v);
		return v;
	}
	
	function get_grab() {
		return getWindowGrab(win);
	}
	
	function set_grab(v) {
		setWindowGrab(win, v);
		return v;
	}

	public function renderTo() {
	}

	public function present() {
	}

	public function destroy() {
		windows.remove(this);
	}

	public function maximize() {
		winResize(win, 0);
	}

	public function minimize() {
		winResize(win, 1);
	}

	public function restore() {
		winResize(win, 2);
	}

	static function winCreateEx( x : Int, y : Int, width : Int, height : Int, sdlFlags : Int) : WinPtr {
		return null;
	}

	static function winCreate( width : Int, height : Int, sdlFlags : Int ) : WinPtr {
		return null;
	}

	static function winSetTitle( win : WinPtr, title : hl.Bytes ) {
	}

	static function winSetPosition( win : WinPtr, width : Int, height : Int ) {
	}

	static function winGetPosition( win : WinPtr, width : hl.Ref<Int>, height : hl.Ref<Int> ) {
	}





	static function winSetFullscreen( win : WinPtr, mode : DisplayMode ) {
		return false;
	}

	@:hlNative("?sdl", "win_set_display_mode")
	static function winSetDisplayMode( win : WinPtr, width : Int, height : Int, framerate : Int ) {
		return false;
	}

	@:hlNative("?sdl", "win_display_handle")
	static function winDisplayHandle( win : WinPtr ) : Int {
		return 0;
	}

	static function winSetSize( win : WinPtr, width : Int, height : Int ) {
	}

	static function winResize( win : WinPtr, mode : Int ) {
	}

	static function winSetMinSize( win : WinPtr, width : Int, height : Int ) {
	}

	static function winSetMaxSize( win : WinPtr, width : Int, height : Int ) {
	}

	static function winGetSize( win : WinPtr, width : hl.Ref<Int>, height : hl.Ref<Int> ) {
	}

	static function winGetMinSize( win : WinPtr, width : hl.Ref<Int>, height : hl.Ref<Int> ) {
	}

	static function winGetMaxSize( win : WinPtr, width : hl.Ref<Int>, height : hl.Ref<Int> ) {
	}

	static function winGetOpacity( win : WinPtr ) : Float {
		return 0.0;
	}

	static function winSetOpacity( win : WinPtr, opacity : Float ) : Bool {
		return false;
	}

	



	static function setWindowGrab( win : WinPtr, grab : Bool ) {
	}
	
	static function getWindowGrab( win : WinPtr ) : Bool {
		return false;
	}
	
	static function warpMouseInWindow( win : WinPtr, x : Int, y : Int ) : Void {
	}

}
