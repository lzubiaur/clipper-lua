local ffi = require 'ffi'
-- ffi.load doesn't use package.cpath to search for libraries but rather the
-- default OS default search path (e.g. LD_LIBRARY_PATH).
local C = ffi.load 'polyclipping'

ffi.cdef[[

typedef struct __IntPoint { int64_t x, y; } IntPoint;
typedef struct __cl_path cl_path;
typedef struct __cl_paths cl_paths;
typedef struct __cl_clipper_offset cl_clipper_offset;

// Path
cl_path* cl_path_new();
void cl_path_free(cl_path *self);
IntPoint* cl_path_get(cl_path *self, int i);
void cl_path_add(cl_path *self, int x, int y);
int cl_path_size(cl_path *self);

// Paths
cl_paths* cl_paths_new();
void cl_paths_free(cl_path *self);
cl_path* cl_paths_get(cl_paths *self, int i);
void cl_paths_add(cl_paths *self, cl_path *path);
int cl_paths_size(cl_paths *self);

// ClipperOffset
cl_clipper_offset* cl_clipper_offset_new(double miterLimit,double roundPrecision);
cl_paths* cl_offset_path(cl_clipper_offset *self, cl_path *subj, int offset, int jointType, int endType);
cl_paths* cl_offset_paths(cl_clipper_offset *self, cl_paths *subj, int offset, int jointType, int endType);
]]

-- enum InitOptions {ioReverseSolution = 1, ioStrictlySimple = 2, ioPreserveCollinear = 4};

local JoinType = {
	square = 0,
	round = 1,
	miter = 2
}

local EndType = {
	closedPolygon = 0,
	closedLine = 1,
	openButt = 2,
	openSquare = 3,
	openRound = 4
}

local Path = {}

function Path.new()
	return ffi.gc(C.cl_path_new(), C.cl_path_free)
end

function Path:add(x,y)
  return C.cl_path_add(self,x,y)
end

function Path:get(i)
  return C.cl_path_get(self,i-1)
end

function Path:size()
	return C.cl_path_size(self)
end

local Paths = {}

function Paths.new()
	return ffi.gc(C.cl_paths_new(), C.cl_paths_free)
end

function Paths:add(path)
  return C.cl_paths_add(self,path)
end

function Paths:get(i)
  return C.cl_paths_get(self,i-1)
end

function Paths:size()
	return C.cl_paths_size(self)
end

local ClipperOffset = {}

function ClipperOffset.new(miterLimit,roundPrecision)
  return C.cl_clipper_offset_new(miterLimit or 2,roundPrecision or 0.25);
end

function ClipperOffset:offsetPath(path,offset,jt,et)
	assert(JoinType[jt])
	assert(EndType[et])
	return C.cl_offset_path(self,path,offset,JoinType[jt],EndType[et])
end

function ClipperOffset:offsetPaths(paths,offset,jt,et)
	assert(JoinType[jt])
	assert(EndType[et])
	return C.cl_offset_paths(self,paths,offset,JoinType[jt],EndType[et])
end

ffi.metatype('cl_path', {__index = Path})
ffi.metatype('cl_paths', {__index = Paths})
ffi.metatype('cl_clipper_offset', {__index = ClipperOffset})

return {
  Path = Path.new,
  Paths = Paths.new,
  ClipperOffset = ClipperOffset.new,
}
