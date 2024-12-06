package;

import idl.Options;


class SDL2Code extends idl.CustomCode {
    public override function getHLInclude() {
		return "
        #ifdef _WIN32
#pragma warning(disable:4305)
#pragma warning(disable:4244)
#pragma warning(disable:4316)
#endif

        ";
	}

	public override function getJVMInclude() {
		return "";
	}

	public override function getEmscriptenInclude() {
		return "";
	}

	public override function getJSInclude() {
		return "";
	}

	public override function getHXCPPInclude() {
		return "";
	}

}
class Generator {
	// Put any necessary includes in this string and they will be added to the generated files
	
	public static function main() {
        trace('Building...');
        var sampleCode : idl.CustomCode = new SDL2Code();
        var options = {
            idlFile: "lib/sdl/sdl2.idl",
            target: null,
            packageName: "sdl",
            nativeLib: "sdl",
            glueDir: null,
            autoGC: true,
            defaultConfig: "Release",
            architecture: ArchAll,
            customCode: sampleCode,
			includes: []
        };

		new idl.Cmd(options).run();
	}
}
