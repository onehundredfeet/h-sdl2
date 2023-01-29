package sdl;


typedef Native = haxe.macro.MacroType<[webidl.Module.build({ idlFile : "sdl/sdl2.idl", chopPrefix : "rc", autoGC : true, nativeLib : "sdl2" })]>;
