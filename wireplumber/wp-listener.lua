#!/usr/bin/wpexec

local configured_name = nil
local live_name = nil

local sinks_om = ObjectManager {
  Interest {
    type = "node",
    Constraint { "media.class", "equals", "Audio/Sink" }
  }
}

local default_node_om = ObjectManager {
  Interest {
    type = "metadata",
    Constraint { "metadata.name", "equals", "default" }
  }
}

local function sink_exists(name)
  if not name then return false end
  for node in sinks_om:iterate() do
    if node.properties["node.name"] == name then
      return true
    end
  end
  return false
end

local function resolve_default_name()
  if sink_exists(configured_name) then
    return configured_name
  end
  return live_name
end

default_node_om:connect("object-added", function(_, metadata)
  for _, key, _, value in metadata:iterate(-1) do
    if key == "default.configured.audio.sink" then
      configured_name = value:match('"name":"([^"]*)"')
      print(configured_name)
    elseif key == "default.audio.sink" then
      live_name = value:match('"name":"([^"]*)"')
      print(live_name)
    end
  end

  metadata:connect("changed", function(_, _, key, _, value)
    if key == "default.configured.audio.sink" then
      configured_name = value:match('"name":"([^"]*)"')
      print("default sink changed")
    elseif key == "default.audio.sink" then
      live_name = value:match('"name":"([^"]*)"')
      print("default sink changed")
    end
  end)
end)

sinks_om:connect("object-added", function(_, node)
  node:connect("params-changed", function(node, param)
    if param == "Props" and node.properties["node.name"] == resolve_default_name() then
      print("default sink props changed")
    end
  end)
end)

default_node_om:activate()
sinks_om:activate()
