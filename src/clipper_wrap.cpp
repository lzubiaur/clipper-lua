#include <stdio.h>
#include "clipper.hpp"

using namespace ClipperLib;

#ifdef __MINGW32__
	#define export extern "C" __declspec (dllexport)
#else
	#define export extern "C" __attribute__ ((visibility ("default")))
#endif

export Path* clipper_path_new() {
	return new Path();
}

export void clipper_path_free(Path *path) {
	delete path;
}

export IntPoint* clipper_path_get(Path *path, int i) {
	return &((*path)[i]);
}

export void clipper_path_add(Path *path, int x, int y) {
	path->push_back(IntPoint(x,y));
}

export ClipperOffset* clipper_offset_new() {
  return new ClipperOffset();
}

// export Paths* clipper_paths_offset(ClipperOffset*, Paths *subj,int offset) {
//   Paths *solution = new Paths();
//   co.AddPaths(*subj, jtRound, etOpenSquare);
//   co.Execute(*solution,offset);
//   return solution;
// }
