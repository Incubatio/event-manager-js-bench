memwatch = require('memwatch')
hd = new memwatch.HeapDiff()
    
class Events
  _events: null

  constructor: (@_events = {}) ->

  on: (name, cb) ->
    if(!@_events[name]) then @_events[name] = []
    @_events[name].push cb

  trigger: (name, target = null, argv = {}, callback = null) ->
    if @_events[name]
      for cb in @_events[name]
        cb({name: name, ctx: target, params: argv})

cb = (e) => total += e.ctx.a + e.params.a + e.params.b + e.params.c
    

# empty class
class Test

e = new Events()
e.on('test', cb)

items = {}
for i in [0...10000]
  items[i] = new Test()
  items[i].a = i
  
  
start = new Date().getTime()
total = 0
params = {a:1, b:2, c:3}
name = 'test'
for j in [0...10000]
  for i in [0...10000]
    e.trigger(name, items[i], params)


end = new Date().getTime()
diff = hd.end()
console.log ['res: ' + total, end - start + ' ms'].join(', '), diff
