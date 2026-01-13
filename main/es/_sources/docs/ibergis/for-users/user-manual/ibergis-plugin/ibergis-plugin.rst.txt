==============
IberGIS Plugin
==============

.. only:: html

    .. contents::
       :local:

The IberGIS plugin is an essential tool for integrated water cycle management.

It has two toolbars: *Main* and *Utilities*.

Toolbar *Main*
==============

.. figure:: img/ibergis-toolbars/main-toolbar.png

    Toolbar *Main*.

This toolbar contains the following buttons:

- **Import INP:** allows you to import an inp file. For more details, see the section :ref:`dialog-import-inp`.
- **Boundary conditions manager:** allows you to manage the boundary conditions. For more details, see the section :ref:`dialog-boundary-cond-manager`.
- **Create boundary condition:** allows you to create boundary conditions. For more details, see the section :ref:`dialog-create-boundary-cond`.
- **Non visual objects manager:** allows you to manage the non visual objects of the project. For more details, see the section :ref:`dialog-non-visual-obj`.
- **Bridge actions:** allows you to add or edit a bridge. For more details, see the section :ref:`dialog-bridge-actions`.

.. toctree::
   :maxdepth: 2

   dialogs/import-inp
   dialogs/boundary-cond-manager
   dialogs/create-boundary-cond
   dialogs/non-visual-obj
   dialogs/bridge-actions

Toolbar *Utilities*
===================

.. figure:: img/ibergis-toolbars/utilities-toolbar.png

    Toolbar *Utilities*.

This toolbar contains the following buttons:

- **Options:** allows you to manage all SWMM and Iber options in one place. For more details, see the section :ref:`dialog-go2iber-options`.
- **Generate INP:** allows you to export the network to an inp file. For more details, see the section :ref:`dialog-generate-inp`.
- **Mesh manager:** allows you to manage the meshes of the project. For more details, see the section :ref:`dialog-mesh-manager`.
- **Execute model:** allows you to execute the model to simulate the network. For more details, see the section :ref:`dialog-execute-model`.
- **Results:** contains many tools for working with the simulation results. For more details, see the section :ref:`dialog-results`.
- **Check project:** allows you to check the project in order to find errors. For more details, see the section :ref:`dialog-check-project`.

.. toctree::
   :maxdepth: 2

   dialogs/go2iber-options
   dialogs/generate-inp
   dialogs/mesh-manager
   dialogs/execute-model
   dialogs/results
   dialogs/check-project