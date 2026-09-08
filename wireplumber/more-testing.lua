#!/usr/bin/wpexec

local current_default_name = nil

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
  --  print("metadata object added, seeding current entries:")
  --  for subject, key, value_type, value in metadata:iterate(-1) do
  --    print("seed", subject, key, value_type, value)
  --  end

  for _, key, _, value in metadata:iterate(-1) do
    if key == "default.configured.audio.sink" then
      current_default_name = value:match('"name": "(.*)"')
      print(current_default_name)
    end
  end

  metadata:connect("changed", function(_, subject, key, value_type, value)
    --    print("changed:", subject, key, value_type, value)
    if key == "default.configured.audio.sink" then
      current_default_name = value:match('"name": "(.*)"')
      print(current_default_name)
    end
  end)
end)

sinks_om:connect("object-added", function(_, node)
  node:connect("params-changed", function(node, param)
    if param == "Props" and node.properties["node.name"] == current_default_name then
      print(current_default_name)
    end
  end)
end)

default_node_om:activate()
sinks_om:activate()
