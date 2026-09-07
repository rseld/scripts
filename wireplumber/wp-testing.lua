#!/usr/bin/wpexec

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

default_node_om:connect("object-added", function(_, metadata)
  metadata:connect("changed", function(_, subject)
    if subject == "default.audio.sink" then
      print("Default sink changed")
    end
  end)
end)

sinks_om:connect("object-added", function(_, node)
  node:connect("params-changed", function(node, param)
    if param == "Props" then
      print("Default sink props changed")
    end
  end)
end)

default_node_om:activate()
sinks_om:activate()
