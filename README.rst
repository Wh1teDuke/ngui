

====
NGUI
====
  
Introduction
============

*Not to be confused with* `NiGui <https://github.com/trustable-code/NiGui>`_, 
NGUI is an interface of GUI toolkits (a.k.a. thin layer on top of GTK3). Use
this library to make GUI applications in Nim.

|

- `Learn <./docs/html/learn.html>`_
- `API <./docs/html/ngui.html>`_
- `Architecture <./docs/html/architecture.html>`_

Installation
============

.. code-block:: cmd

  # Install Nim
  https://nim-lang.org/install.html
  # Install GTK3
  https://www.gtk.org/docs/installations/
  # Install NGUI
  git clone ...
  # OPTIONAL
  cd NGUI_DIR
  nim addPath niguiscipt.nims

|
  
Backends
========

======= =====================================================================
Backend Source
======= =====================================================================
GTK3    https://github.com/StefanSalewski/oldgtk3 *Domo arigato gozaimashita*
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
