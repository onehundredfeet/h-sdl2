#pragma once

#if defined(_WIN32) || defined(__ANDROID__) || defined(IDL_IOS) || defined(IDL_TVOS)
#	include <SDL.h>
#	include <SDL_vulkan.h>
#	include <SDL_syswm.h>
#else
#	include <SDL2/SDL.h>
#endif

#if defined (IDL_IOS) || defined(IDL_TVOS)
#	include <OpenGLES/ES3/gl.h>
#	include <OpenGLES/ES3/glext.h>
#endif

#ifndef SDL_MAJOR_VERSION
#	error "SDL2 SDK not found in hl/include/sdl/"
#endif
