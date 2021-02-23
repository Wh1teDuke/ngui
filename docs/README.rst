

====
NGUI
====


.. contents::


Introduction
============

*Not to be confused with* `NiGui <https://github.com/trustable-code/NiGui>`_, 
**NGUI** is an interface of GUI toolkits (a.k.a. thin layer on top of GTK3). Use
this library to make GUI applications in **Nim**.

|

- `Learn <https://wh1teduke.github.io/ngui/html/learn.html>`_
- `API <https://wh1teduke.github.io/ngui/html/ngui.html>`_
- `Architecture <https://wh1teduke.github.io/ngui/html/architecture.html>`_

Installation
============

.. code-block:: bash

  # Install Nim
  https://nim-lang.org/install.html
  # Install GTK3
  https://www.gtk.org/docs/installations/
  # Install NGUI
  git clone https://github.com/Wh1teDuke/ngui
  # OPTIONAL
  cd NGUI_DIR
  nim addPath nguiscript.nims

|
  
Backends
========

======= =====================================================================
Backend Source
======= =====================================================================
GTK3    https://github.com/StefanSalewski/oldgtk3 *Domo arigato gozaimashita*
GTK2    https://github.com/nim-lang/gtk2 *Domo arigato gozaimashita*
======= =====================================================================

|

Status
======
  
Beta alpha alpha quality.

- Needs exhaustive testing
- Only tested on linux
- Better documentation
- More backends, prune some GTK3 binding files
- A logo for the project

|

License
=======

See `LICENSE <./LICENSE.rst>`_ (MIT)
