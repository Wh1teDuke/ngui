
=====
Learn
=====

:Author: WhiteDuke
:Summary: NGUI tutorial


.. contents::


Introduction
============
  
In this document **ngui** is introducted. **Ngui** uses many conventions
commonly used in gui toolkits, so you may benefit from reviewing them. Here is
a list of useful links in case you need them:

Useful Links
------------

- `MVC <https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller>`_
- `Event Loop <https://en.wikipedia.org/wiki/Event_loop>`_
- `List of graphical user interface elements <https://en.wikipedia.org/wiki/List_of_graphical_user_interface_elements>`_
- `Getting Started with GTK+ <https://developer.gnome.org/gtk3/stable/gtk-getting-started.html>`_
- NGUI
   - `NGUI API <ngui.html>`_
   - `NGUI backend interface <ngui_backend_interface.html>`_
   - `Nim GTK3 Bindings <https://github.com/StefanSalewski/oldgtk3>`_


About NGUI
----------

**NGUI** is an *interface of user interfaces*, or to put it simply, a thin layer
over someone else's GUI toolkit code to program GUI's in a less cumbersome
fashion. At the time of writting this document, only
`GTK3 <https://github.com/StefanSalewski/oldgtk3>`_ is supported, but
in the future more gui backends will follow, I assume.


.. code-block:: nim

  let app = app()               # Lib initialization
  app.add(window())             # Add Window Element
  app[0].add(label("NGUI"))     # Add label to Window
  app.run                       # Show app, block thread, listen to user events


Nomenclature
------------

=========  ============
NGUI       Common Terms
=========  ============
NElement   `Widget <https://en.wikipedia.org/wiki/Widget_(GUI)>`_
Container  Container
Box        Box
Window     `Window <https://en.wikipedia.org/wiki/Window_(computing)>`_
Label      Label
Bar        Menu Bar
Menu       Menu
Tabs       `Tab Bar <https://en.wikipedia.org/wiki/Tab_(interface)>`_
Table      Table
Frame      Frame
Image      Image
Atom       
Button     `Button <https://en.wikipedia.org/wiki/Button_(computing)>`_
=========  ============


Your first application
======================
  
In this example, a window will display a button which, upon clicking, will
close the application:

.. code-block:: nim

  # Lib initialization, first thing you need to do before using any element
  let app = app()
  
  # Add a new button with the given label. It will create a new 'Window' and
  # 'Box' element under the hood for you
  app.add(button("Close Now"))
  
  # Attach onClick event to button. The button is inside a box, which is itself
  # inside a window inside the app context variable. They were created for your
  # convenience
  # App[0] -> Window[0] -> Box[0] -> button
  app[0][0][0].onClickDo:
    quit()
  
  # This call will display the gui and block the thread, executing only user
  # events (like the previously defined one) until a close event is sent
  app.run

|
  
.. Note:: If you need to do some work in the meantime, use
          `threads <https://nim-lang.org/docs/manual.html#threads>`_

|

The `app` variable is a `Container`, that's why we can get the appended elements
using array notation. However, conversion is needed. `Window` and `Container`
elements were added the moment you added the button. That code is similar to
this one:
  
.. code-block:: nim

  let window = window()
  let box = box()
  let button = button("Close now")
  box.add(button)
  window.add(box)
  app.add(window)
  
  button.onClickDo:
    quit()


More
====
  
For more examples, have a look at the `examples` folder, or execute:
  
.. code-block:: nim

  nim examples nguiscript.nims


.. Warning:: WORK IN PROGRESS
