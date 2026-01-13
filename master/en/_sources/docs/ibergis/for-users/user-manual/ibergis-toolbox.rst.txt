===============
IberGIS toolbox
===============

.. only:: html

   .. contents::
      :local:

The toolbox is the set of IberGIS tools that allows to import, debug and validate project layers to run hydraulic simulations.

.. figure:: img/ibergis-toolbox.png

   IberGIS toolbox.

To run a process, simply double-click on its name in the toolbox.

Process dialog box
==================

After double-clicking on the process, a dialog box similar to the one shown in the following figure will open.

.. figure:: img/import-ground-geometries.png

   Dialog of Import Ground Geometries.

The dialog show two tabs on the left (Config and Info log), the description of the process on the right and a set of buttons.

Tab *Config*
------------

In this tab, we must establish the input values that the process needs to be executed, as well as the configuration parameters that must be specified.

The input values will depend on the process being executed, so the dialog box will be different for each process.

Tab *Info log*
--------------

It shows a summary of the process that has been carried out.

.. figure:: img/import-ground-geometries-log.png

   Example of a process summary.

Process results
===============

The execution of certain processes involves the creation of temporary layers with the results.
These layers will be loaded into the ToC in a group and their geometry will depend on the geometry of the input layer.



