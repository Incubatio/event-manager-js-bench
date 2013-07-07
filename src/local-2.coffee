memwatch = require('memwatch')
hd = new memwatch.HeapDiff()
    
class Events
  _eventables: null

  constructor: (@_eventables = []) ->

  on: (name, cb) ->
    if(!@_events[name]) then @_events[name] = []
    @_events[name].push cb

  trigger: (name, argv = {}, callback = null) ->
    if @_events[name]
      for cb in @_events[name]
        cb({name: name, ctx: @, params: argv})

  eventize: (obj) ->
    @_eventables.push obj
    obj.e = @
    obj._events = {}
    obj.on = @on
    obj.trigger = @trigger

#empty class
class Test

cb = (e) => total += e.ctx.a + e.params.a + e.params.b + e.params.c


items = []
e = new Events()
for i in [0...10000]
  t = new Test()
  t.a = i
  e.eventize(t)
  t.on('test', cb)
  items[i] = t

  
start = new Date().getTime()
total = 0
params = {a:1, b:2, c:3}
name = 'test'
for j in [0...10000]
  for i in [0...10000]
    items[i].trigger(name, params)

end = new Date().getTime()
diff = hd.end()
console.log ['res: ' + total, end - start + ' ms'].join(', '), diff
