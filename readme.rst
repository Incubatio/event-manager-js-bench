==========================
Event Manager js benchmark
==========================


PROBLEM
-------
Basically need a nice and performant event management to keep a flexible entity-component-system implementation.
For example, between games, collision detection and following sprite reaction is probably what can change the most. 
In a ECS architecture, we want system to manage entities logic.
e.g. Sword should damage on collision, ghosts skip the collision, heart regenerate, items go into inventory, etc ...


THOUGHTS
--------
The less intrusive way, the one which could keep our collision system "pure" and super flexible is triggering event.
Indeed, in the system you need nothing more than the sprite itself and additional call with collision details as param.

Two solution:
1. "local event mangement":
```js myEntity.trigger('collide', {to: theOtherEntity, [...]})
2. "global event manager":
```js myEventManager.trigger('collide', myEntity, {to: theOtherEntity, [...])

I described a bit the pro and con here: https://github.com/Incubatio/gamecs/issues/2

In the current context of game, I chose to use a "local event mangement" because I think I need granularity.


PROCEDURE
--------
1. compile coffee using following cmd:
```coffee --compile --output build src```

2. then from path/to/project/build:
```node <eventManager_to_bench.js>```

I know it's a fast benching technique, but was enough for that precise case.

Details
~~~~~~~
10 000 event calls for each 10 000 object, 100 000 000 calls total.

Results
~~~~~~~
+----------------+---------------+-----------------+
| **Target**     |    **RAM**    |  **Duration**   |
+----------------+---------------+-----------------+
| global.coffee  |  ~ 422 kb     |   11941 ms      |
+----------------+---------------+-----------------+
| local-1.coffee |  ~ 2.87 mo    |   13367 ms      |
+----------------+---------------+-----------------+
| local-2.cofee  |  ~ 3.02 mo    |   12843 ms      |
+----------------+---------------+-----------------+
| mix.coffee     |  ~ 3.68 mo    |   46366 ms      |
+----------------+---------------+-----------------+
