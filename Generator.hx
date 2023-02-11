package ;

#if eval
class Generator {

	// Put any necessary includes in this string and they will be added to the generated files
	
	public static function generateCpp(target:String) {	
		var INCLUDE = '
		#ifdef _WIN32
		#pragma warning(disable:4305)
		#pragma warning(disable:4244)
		#pragma warning(disable:4316)
		#endif
		
		
		#include \"${target}-sdl2.h\"
		';
		var options = { idlFile : "lib/sdl/sdl2.idl", nativeLib : "sdl2", outputDir : "src/"+target, includeCode : INCLUDE, autoGC : true, target: target };
		idl.Generate.generateCpp(options);
	}

}
#end