local ffi = require 'ffi'
-- ffi.load doesn't use package.cpath to search for libraries but rather the
-- default OS default search path (e.g. LD_LIBRARY_PATH).
local C = ffi.load 'polyclipping'

ffi.cdef[[

typedef struct _IntPoint { int64_t x, y; } IntPoint;
typedef struct _clipper_path clipper_path;
typedef struct _clipper_offset clipper_offset;

clipper_path* clipper_path_new();
void clipper_path_free(clipper_path *path);
IntPoint* clipper_path_get(clipper_path *path, int i);
void clipper_path_add(clipper_path *path, int x, int y);

clipper_offset* clipper_offset_new();
clipper_offset* clipper_paths_offset(clipper_path *subjects,int offset);
]]

local Path = {}

function Path.new()
	return ffi.gc(C.clipper_path_new(), C.clipper_path_free)
end

function Path:add(x,y)
  return C.clipper_path_add(self,x,y)
end

function Path:get(i)
  return C.clipper_path_get(self,i-1)
end

local ClipperOffset = {}

function ClipperOffset.new()
  return C.clipper_offset_new();
end

ffi.metatype('clipper_path', {__index = Path})

return {
  Path = Path.new,
  ClipperOffset = ClipperOffset.new,
}
