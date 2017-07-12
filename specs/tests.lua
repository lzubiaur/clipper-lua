local clipper = require 'clipper'
local lust = require 'lust'
local describe, it, expect = lust.describe, lust.it, lust.expect

describe('test clipper ffi binding', function()
  lust.before(function()
  end)

  describe('test path', function()
    it('create new path object',function()
      local path = clipper.Path()
      lust.expect(path).to.exist()
    end)
    it('add and get point',function()
      local path = clipper.Path()
      path:add(10,20)
      lust.expect(path:get(1).x).to.be(10)
      lust.expect(path:get(1).y).to.be(20)
    end)
  end)
end)
