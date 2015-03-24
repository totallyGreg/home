from beautifulhue.api import Bridge

bridge = Bridge(device={'ip':'10.0.1.15'}, user={'name':'newdeveloper'})
resource = {'which':'all'}}
bridge.light.get(resource)
