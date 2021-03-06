local clipper = require 'clipper'
local lust = require 'lust'
local describe, it, expect, before = lust.describe, lust.it, lust.expect, lust.before

describe('test Clipper FFI binding', function()
  describe('path usage', function()
    it('can create and delete path',function()
      local path = clipper.Path()
      expect(path).to.exist()
      path = nil
      collectgarbage('collect')
    end)
    it('can add and get point',function()
      local path = clipper.Path()
      expect(path:add(10,20)).to.be(true)
      expect(path:get(1).x).to.be(10)
      expect(path:get(1).y).to.be(20)
      path:add(20,20)
      path:add(40,40)
      path:add(50,120)
      expect(path:size()).to.be(4)
    end)
    local p = clipper.Path()
    it('can get path area', function()
      p:add(100,100)
      p:add(150,100)
      p:add(150,150)
      p:add(100,150)
      expect(p:area()).to.be(2500)
    end)
    it('can get path orientation',function()
      expect(p:orientation()).to.be(true)
    end)
    it('can reverse path orientation',function()
      p:reverse()
      expect(p:orientation()).to.be(false)
    end)
    it('can check it contains a point',function()
      expect(p:contains(10,10)).to.be(0)
      expect(p:contains(100,100)).to.be(-1)
      expect(p:contains(125,125)).to.be(1)
    end)
    it('can simplify path',function()
      p = clipper.Path()
      p:add(100,100)
      p:add(150,100)
      p:add(200,100)
      p:add(200,150)
      local paths = p:simplify()
      expect(paths:size()).to.be(1)
      local p = paths:get(1)
      expect(p:size()).to.be(3)
    end)
    it('can clean polygon', function()
      p = clipper.Path()
      p:add(10,10)
      p:add(100,10)
      p:add(100,100)
      p:add(10,100)
      p:add(10,50)
      local out = p:cleanPolygon()
      expect(out:size()).to.be(4)
    end)
  end)

  describe('paths usage', function()
    it('can create and delete paths', function()
      local paths = clipper.Paths()
      expect(paths).to.exist()
      paths = nil
      collectgarbage('collect')
    end)
    it('can add path',function()
      local p = clipper.Path()
      p:add(10,20)
      p:add(100,30)
      local paths = clipper.Paths()
      expect(paths:add(p)).to.be(true)
    end)
    it('can add and get path', function()
      local p1 = clipper.Path()
      p1:add(10,10)
      p1:add(20,20)
      p1:add(30,50)
      local p2 = clipper.Path()
      p2:add(50,50)
      p2:add(100,60)
      local paths = clipper.Paths()
      paths:add(p1)
      paths:add(p2)
      expect(paths:size()).to.be(2)
      expect(paths:get(1):get(1).x).to.be(10)
      expect(paths:get(1):get(1).y).to.be(10)
      expect(paths:get(1):get(2).x).to.be(20)
      expect(paths:get(1):get(2).y).to.be(20)
      expect(paths:get(1):get(3).x).to.be(30)
      expect(paths:get(1):get(3).y).to.be(50)
      expect(paths:get(2):get(1).x).to.be(50)
      expect(paths:get(2):get(1).y).to.be(50)
      expect(paths:get(2):get(2).x).to.be(100)
      expect(paths:get(2):get(2).y).to.be(60)
    end)
  end)
  describe('paths offset',function()
    it('can create and delete ClipperOffset',function()
      local co = clipper.ClipperOffset()
      expect(co).to.exist()
      collectgarbage('collect')
    end)
    local co = clipper.ClipperOffset()
    it('can offset a single path',function()
      local p = clipper.Path()
      p:add(10,20)
      p:add(50,20)
      p:add(50,50)
      local out = co:offsetPath(p,10,'miter','openButt')
      expect(out:size()).to.be(1)
      expect(out:get(1):size()).to.be(6)
    end)
    it('can clear all paths', function()
      co:clear()
      local p = clipper.Path()
      p:add(100,100)
      p:add(20,150)
      local out = co:offsetPath(p,10,'miter','openButt')
      expect(out:get(1):size()).to.be(4)
    end)
    it('can offset multiple paths',function()
      co:clear()
      local p1 = clipper.Path()
      p1:add(100,100)
      p1:add(20,150)
      local p2 = clipper.Path()
      p2:add(200,200)
      p2:add(250,250)
      local p = clipper.Paths()
      p:add(p1)
      p:add(p2)
      local out = co:offsetPaths(p,10,'miter','openButt')
      expect(out:size()).to.be(2)
      expect(out:get(1):size()).to.be(4)
      expect(out:get(2):size()).to.be(4)
    end)
    it('can raise error',function()
      co:clear()
      local p1 = clipper.Path()
      p1:add(0x3FFFFFFFFFFFFFFFLL,100)
      local p = clipper.Paths()
      p:add(p1)
      -- Coordinate outside allowed range
      expect(function() co:offsetPaths(p,10) end).to.fail()
    end)
  end)

  describe('polygon clipping', function()
    it('calls destructor', function()
      local cl = clipper.Clipper()
      expect(cl).to.exist()
      cl = nil
      collectgarbage('collect')
    end)
    local cl = clipper.Clipper()
    it('can add path', function()
      local p = clipper.Path()
      p:add(10,20)
      p:add(50,20)
      expect(function() cl:addPath(p,'unknown type') end).to.fail()
      expect(function() cl:addPath(nil) end).to.fail()
      cl:addPath(p,'subject')
    end)
    it('can add paths', function()
      local p = clipper.Path()
      p:add(10,20)
      p:add(100,30)
      local paths = clipper.Paths()
      paths:add(p)
      -- Error: Open paths must be subject
      expect(function() cl:addPaths(paths,'clip',false) end).to.fail()
      cl:addPaths(paths,'clip',true)
    end)
    it('can get aabb of all polygons',function()
      local p = clipper.Path()
      p:add(100,100)
      p:add(150,100)
      p:add(150,150)
      p:add(100,150)
      cl:addPath(p,'subject',true)
      local left,top,right,bottom = cl:getBounds()
      expect({left,top,right,bottom}).to.equal({100,100,150,150})
    end)
    it('can clear all polygon', function()
      cl:clear()
      local left,top,right,bottom = cl:getBounds()
      expect({left,top,right,bottom}).to.equal({0,0,0,0})
    end)
    it('can clip two polygon', function()
      cl:clear()
      local p1 = clipper.Path()
      p1:add(100,100)
      p1:add(150,100)
      p1:add(150,150)
      p1:add(100,150)
      local p2 = clipper.Path()
      p2:add(100,120)
      p2:add(150,120)
      p2:add(150,130)
      p2:add(100,130)
      cl:addPath(p1,'subject')
      cl:addPath(p2,'clip')
      local out = cl:execute('difference')
      expect(out:size()).to.be(2)
    end)
    it('can clip multiple polygons', function()
      -- TODO
    end)
    it('raises error', function()
      cl:clear()
      local p1 = clipper.Path()
      p1:add(100,100)
      p1:add(150,100)
      p1:add(150,150)
      p1:add(100,150)
      local p2 = clipper.Path()
      p2:add(100,150)
      p2:add(150,150)
      cl:addPath(p1,'subject',false)
      cl:addPath(p2,'clip')
      -- Error: PolyTree struct is needed for open path clipping.
      expect(function() cl:execute('intersection') end).to.fail()
    end)
  end)
end)
