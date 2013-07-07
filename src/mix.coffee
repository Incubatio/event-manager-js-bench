memwatch = require('memwatch')
hd = new memwatch.HeapDiff()
    
class EventManager
  _events: null

  constructor: (@_events = {}) ->

  on: (name, cb) ->
    if(!@_events[name]) then @_events[name] = []
    @_events[name].push cb

  trigger: (name, target = null, argv = {}, callback = null) ->
    if @_events[name]
      for cb in @_events[name]
        cb({name: name, ctx: target, params: argv})

class Eventable
  on: (name, cb) ->
    #TOTHINK: maybe add an alternative to the id
    name = (if @id then @id + '_' else '') + name
    @e.on(name, cb)

  trigger: (name, argv = {}, callback = null) ->
    name = (if @id then @id + '_' else '') + name
    @e.trigger(name, @, argv, callback)

class Test extends Eventable
  UID = 0

  constructor: () ->
    @id = ++UID


cb = (e) => total += e.ctx.a + e.params.a + e.params.b + e.params.c

#eventize = (obj, e) ->
#  obj.e = e
#  obj.on = Eventable.on
#  obj.trigger = Eventable.trigger


items = []
e = new EventManager()
for i in [0...10000]
  t = new Test()
  t.a = i
  #eventize(t, e)
  t.e = e
  t.on('test', cb)
  items[i] = t

  
start = new Date().getTime()
total = 0
params = {a:1, b:2, c:3}
name = 'test'
for j in [0...10000]
  for i in [0...10000]
    #e.trigger(name, items[i], params)
    items[i].trigger(name, params)

end = new Date().getTime()
diff = hd.end()
console.log ['res: ' + total, end - start + ' ms'].join(', '), diff
