#include <stdio.h>
#include "clipper.hpp"

using namespace ClipperLib;

#ifdef __MINGW32__
	#define export extern "C" __declspec (dllexport)
#else
	#define export extern "C" __attribute__ ((visibility ("default")))
#endif

// Path

export Path* cl_path_new() {
	return new Path();
}

export void cl_path_free(Path *path) {
	delete path;
}

export IntPoint* cl_path_get(Path *path, int i) {
	return &((*path)[i]);
}

export void cl_path_add(Path *path, int x, int y) {
	path->push_back(IntPoint(x,y));
}

export int cl_path_size(Path *path) {
	return path->size();
}

// Paths

export Paths* cl_paths_new() {
	return new Paths();
}

export void cl_paths_free(Path *paths) {
	delete paths;
}

export Path* cl_paths_get(Paths *paths, int i) {
	return &((*paths)[i]);
}

export void cl_paths_add(Paths *paths, Path *path) {
	paths->push_back(*path);
}

export int cl_paths_size(Paths *paths) {
	return paths->size();
}

// ClipperOffset

export ClipperOffset* cl_clipper_offset_new(double miterLimit,double roundPrecision) {
  return new ClipperOffset(miterLimit,roundPrecision);
}

export Paths* cl_offset_path(ClipperOffset* co,Path *subj,int offset,int joinType,int endType) {
  Paths *solution = new Paths();
  co->AddPath(*subj,JoinType(joinType),EndType(endType));
  co->Execute(*solution,offset);
  return solution;
}

export Paths* cl_offset_paths(ClipperOffset* co,Paths *subj,int offset,int joinType,int endType) {
  Paths *solution = new Paths();
  co->AddPaths(*subj,JoinType(joinType),EndType(endType));
  co->Execute(*solution,offset);
  return solution;
}

export void cl_offset_clear(ClipperOffset *co) {
	co->Clear();
}

// export Paths* clipper_paths_offset(ClipperOffset*, Paths *subj,int offset) {
//   Paths *solution = new Paths();
//   co.AddPaths(*subj, jtRound, etOpenSquare);
//   co.Execute(*solution,offset);
//   return solution;
// }
