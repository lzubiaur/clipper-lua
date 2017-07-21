// Copyright (c) 2017 Laurent Zubiaur
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <stdio.h>
#include "clipper.hpp"

using namespace ClipperLib;

#ifdef _WIN32
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

export double cl_path_area(const Path *path) {
	return Area(*path);
}

export bool cl_path_orientation(const Path *path) {
	return Orientation(*path);
}

export void cl_path_reverse(Path *path) {
	ReversePath(*path);
}

export int cl_path_point_in_polygon(const Path *path, cInt x, cInt y) {
	return PointInPolygon(IntPoint(x,y),*path);
}

export Paths* cl_path_simplify(const Path *in,int fillType) {
	Paths *out = new Paths();
	SimplifyPolygon(*in,*out,PolyFillType(fillType));
	return out;
}

export Path* cl_path_clean_polygon(const Path *in, double distance = 1.415) {
	Path *out = new Path();
	CleanPolygon(*in,*out,distance);
	return out;
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

export Paths* cl_offset_path(ClipperOffset* co,Path *subj,double delta,int joinType,int endType) {
  Paths *solution = new Paths();
	try {
		co->AddPath(*subj,JoinType(joinType),EndType(endType));
		co->Execute(*solution,delta);
	} catch(clipperException &e) {
		err_msg = e.what();
		delete solution;
		return NULL;
	}
  return solution;
}

export Paths* cl_offset_paths(ClipperOffset* co,Paths *subj,double delta,int joinType,int endType) {
  Paths *solution = new Paths();
	try {
  	co->AddPaths(*subj,JoinType(joinType),EndType(endType));
  	co->Execute(*solution,delta);
	} catch(clipperException &e) {
		err_msg = e.what();
		delete solution;
		return NULL;
	}
  return solution;
}

export void cl_offset_clear(ClipperOffset *co) {
	co->Clear();
}

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
		delete solution;
		err_msg = e.what();
		return NULL;
	}
	return solution;
}

export IntRect cl_clipper_get_bounds(Clipper *cl) {
	return cl->GetBounds();
}
