#include <stdio.h>
#include "clipper.hpp"

using namespace ClipperLib;

#ifdef __MINGW32__
	#define export extern "C" __declspec (dllexport)
#else
	#define export extern "C" __attribute__ ((visibility ("default")))
#endif

std::string err_msg;

export const char *cl_err_msg() {
	return err_msg.c_str();
}

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

export bool cl_path_add(Path *path, cInt x, cInt y) {
	try {
		path->push_back(IntPoint(x,y));
		return true;
	} catch(...) {
		return false;
	}
}

export int cl_path_size(Path *path) {
	return path->size();
}

// Paths

export Paths* cl_paths_new() {
	return new Paths();
}

export void cl_paths_free(Paths *paths) {
	delete paths;
}

export Path* cl_paths_get(Paths *paths, int i) {
	return &((*paths)[i]);
}

export bool cl_paths_add(Paths *paths, Path *path) {
	try {
		paths->push_back(*path);
		return true;
	} catch(...) {
		return false;
	}
}

export int cl_paths_size(Paths *paths) {
	return paths->size();
}

// ClipperOffset

export ClipperOffset* cl_offset_new(double miterLimit,double roundPrecision) {
  return new ClipperOffset(miterLimit,roundPrecision);
}

export void cl_offset_free(ClipperOffset *co) {
	delete co;
}

export Paths* cl_offset_path(ClipperOffset* co,Path *subj,double offset,int joinType,int endType) {
  Paths *solution = new Paths();
  co->AddPath(*subj,JoinType(joinType),EndType(endType));
	// XXX check execute return value?
  co->Execute(*solution,offset);
  return solution;
}

export Paths* cl_offset_paths(ClipperOffset* co,Paths *subj,double offset,int joinType,int endType) {
  Paths *solution = new Paths();
  co->AddPaths(*subj,JoinType(joinType),EndType(endType));
  co->Execute(*solution,offset);
  return solution;
}

export void cl_offset_clear(ClipperOffset *co) {
	co->Clear();
}

// export void cl_offset_paths(const Paths &in_polys, Paths &out_polys, double delta, JoinType jointype = jtSquare, EndType endtype = etClosed, double limit = 0.0);

// Clipper

export Clipper* cl_clipper_new(Clipper *cl) {
	return new Clipper();
}

export void cl_clipper_free(Clipper *cl) {
	delete cl;
}

export void cl_clipper_clear(Clipper *cl) {
	cl->Clear();
}

export void cl_clipper_reverse_solution(Clipper *cl, bool value) {
	cl->ReverseSolution(value);
}

export void cl_clipper_preserve_collinear(Clipper *cl, bool value) {
	cl->PreserveCollinear(value);
}

export void cl_clipper_strictly_simple(Clipper *cl, bool value) {
	cl->StrictlySimple(value);
}

export bool cl_clipper_add_path(Clipper *cl,Path *path, int pt, bool closed, const char *err) {
	try {
		cl->AddPath(*path,PolyType(pt),closed);
		return true;
	} catch(clipperException &e) {
		err_msg = e.what();
		return false;
	}
}

export bool cl_clipper_add_paths(Clipper *cl,Paths *paths, int pt, bool closed, const char *err) {
	try {
		cl->AddPaths(*paths,PolyType(pt),closed);
		return true;
	} catch(clipperException &e) {
		err_msg = e.what();
		return false;
	}
}

export Paths* cl_clipper_execute(Clipper *cl,int clipType,int subjFillType,int clipFillType) {
	Paths *solution = new Paths();
	try {
		cl->Execute(ClipType(clipType),*solution,PolyFillType(subjFillType),PolyFillType(clipFillType));
	} catch(clipperException &e) {
		err_msg = e.what();
		return NULL;
	}
	return solution;
}

export IntRect cl_clipper_get_bounds(Clipper *cl) {
	return cl->GetBounds();
}

export double cl_path_area(const Path *path) {
	return Area(*path);
}
