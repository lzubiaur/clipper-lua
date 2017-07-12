local Clipper = require 'clipper'

local paths = {
  { 20,20,50,20,50,50 },
  { 100,100,200,100,150,150 },
  { 200,200,220,250,200,300 }
}
local points = {}

local function newPath(...)
  local p = Clipper.Path()
  local n = select('#',...)
  local t = {...}
  for i=1,n,2 do
    p:add(t[i],t[i+1])
  end
  return p
end

local function getPathPoints(path)
  p = {}
  for i=1,path:size() do
    local point = path:get(i)
    table.insert(p,tonumber(point.x))
    table.insert(p,tonumber(point.y))
  end
  return p
end

function love.load()
  local p = newPath(unpack(paths[1]))
  local co = Clipper.ClipperOffset()
  local out = co:offsetPath(p,10,'miter','openSquare')
  table.insert(points,getPathPoints(out:get(1)))

  local ps = Clipper.Paths()
  ps:add(newPath(unpack(paths[2])))
  ps:add(newPath(unpack(paths[3])))
  local out = co:offsetPaths(ps,10,'miter','openSquare')
  for i=1,out:size() do
    table.insert(points,getPathPoints(out:get(i)))
  end
end

function love.update(dt)
end

function love.draw()
    love.graphics.setLineWidth(2)
    love.graphics.setColor(0,255,0,255)
    for i=1, #paths do
      love.graphics.line(unpack(paths[i]))
    end
    love.graphics.setColor(255,255,0,255)
    for i=1, #points do
      love.graphics.polygon('line',unpack(points[i]))
    end
end
